defmodule GomokuBoardBackendWeb.AIGameChannel do
  use Phoenix.Channel

  def join("AIgame:lobby", _payload, socket) do
    {:ok, socket}
  end

def handle_in("start_ai", %{"command" => command} = message, socket) do
  GomokuBoardBackend.EngineManager.start_engine_and_setup_board(command)
  {:noreply, socket}
end

def handle_in("analyze_position", %{"command" => command} = message, socket) do
  GomokuBoardBackend.EngineManager.analyse(command)
  {:noreply, socket}
end

def handle_in("stop_ai", %{"command" => command} = message, socket) do
  GomokuBoardBackend.EngineManager.stop_engine(command)
  {:noreply, socket}
end

end
