defmodule GomokuBoardBackendWeb.AIGameChannel do
  use Phoenix.Channel

  def join("AIgame:lobby", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("make_move", %{"move" => move} = payload, socket) do
    # Handle incoming move event
    {:noreply, socket}
  end
end
