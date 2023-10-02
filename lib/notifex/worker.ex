defmodule Notifex.Worker do
  use GenServer
  require Logger

  def start_link(args \\ []) when is_list(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(args) do
    {:ok, [], {:continue, :subscribe}}
  end

  def handle_continue(:subscribe, state) do
    otp_app = Application.get_env(:notifex, :otp_app)
    if Application.ensure_all_started(otp_app) do
      pubsub = Application.get_env(:notifex, :pubsub)
      pubsub.subscribe("chat")
      Logger.info("Notifex subscribed to chat")
      {:noreply, state}
    else
      Logger.info("PubSub not started")
      {:stop, "pubsub not started", state}
    end
  end
end
