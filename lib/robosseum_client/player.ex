defmodule RobosseumClient.Player do
  require Logger

  alias Phoenix.Channels.GenSocketClient
  @behaviour GenSocketClient

  def start_link() do
    Logger.info("start link")
    GenSocketClient.start_link(
          __MODULE__,
          Phoenix.Channels.GenSocketClient.Transport.WebSocketClient,
          "ws://localhost:4000/socket/websocket"
        )
  end

  def init(url) do
    {:connect, url, [type: :player, id: System.get_env("player")], %{table_id: System.get_env("table")}}
  end

  def handle_connected(transport, state) do
    Logger.info("connected")
    GenSocketClient.join(transport, "table:#{state.table_id}")
    {:ok, state}
  end

  def handle_disconnected(reason, state) do
    Logger.error("disconnected: #{inspect reason}")
    Process.send_after(self(), :connect, :timer.seconds(1))
    # System.stop(0)
    {:ok, state}
  end

  def handle_joined(topic, payload, _transport, state) do
    Logger.info("joined the topic #{topic}")
    Logger.info(inspect payload)
    {:ok, state}
  end

  def handle_join_error(topic, payload, _transport, state) do
    Logger.error("join error on the topic #{topic}: #{inspect payload}")
    {:ok, state}
  end

  def handle_channel_closed(topic, payload, _transport, state) do
    Logger.error("disconnected from the topic #{topic}: #{inspect payload}")
    # Process.send_after(self(), {:join, topic}, :timer.seconds(1))
    {:ok, state}
  end

  def handle_message(topic, "bid", %{"player" => %{"to_call" => to_call}} = payload, transport, state) do
    Logger.info("message on topic #{topic}: bid #{inspect payload}")
    action =
      case Enum.random(0..100) do
        x when x in 0..10 -> :fold
        x when x in 11..50 -> :call
        x when x in 51..100 -> :bid
      end
    GenSocketClient.push(transport, topic, "player_action", %{bid: Enum.random(to_call..100), action: action})
    {:ok, state}
  end

  def handle_message(topic, event, payload, _transport, state) do
    Logger.warn("message on topic #{topic}: #{event}")
    {:ok, state}
  end

  # def handle_disconnect(reason, state) do
  #   Logger.error("disconnected: #{inspect reason}")
  #   {:ok, state}
  # end

  # def handle_reply(topic, _ref, payload, _transport, state) do
  #   Logger.warn("reply on topic #{topic}: #{inspect payload}")
  #   {:ok, state}
  # end

  def handle_info(:connect, _transport, state) do
    Logger.info("connecting")
    {:connect, state}
  end

  # def handle_info({:join, topic}, transport, state) do
  #   Logger.info("joining the topic #{topic}")
  #   case GenSocketClient.join(transport, topic) do
  #     {:error, reason} ->
  #       Logger.error("error joining the topic #{topic}: #{inspect reason}")
  #       Process.send_after(self(), {:join, topic}, :timer.seconds(1))
  #     {:ok, _ref} -> :ok
  #   end

  #   {:ok, state}
  # end

  def handle_info(message, _transport, state) do
    Logger.warn("Unhandled message #{inspect message}")
    {:ok, state}
  end
end
