defmodule GomokuBoardBackendWeb.AIGameChannel do
  use Phoenix.Channel

  def join("AIgame:lobby", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("engine_output", payload, socket) do
    # Handle incoming messages from the engine
    {:noreply, socket}
  end

  def handle_in("make_move", %{"move" => move} = payload, socket) do
    # Handle incoming move event
    {:noreply, socket}
  end
end
