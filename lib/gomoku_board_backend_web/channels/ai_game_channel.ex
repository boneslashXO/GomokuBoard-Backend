defmodule GomokuBoardBackendWeb.AIGameChannel do
  use Phoenix.Channel

  def join("AIgame:lobby", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("start_game", _message, socket) do
  GomokuBoardBackend.EngineManager.start_engine_and_setup_board("START 15\n")
  {:noreply, socket}
  end

  def handle_in("send_something", %{"content" => content}, socket) do
  #EngineManager.start_engine_and_setup_board("START 15\n")
       IO.puts("Message received: #{content}")
  {:noreply, socket}
  end

end
