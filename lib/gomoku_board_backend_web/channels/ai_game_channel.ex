defmodule GomokuBoardBackendWeb.AIGameChannel do
  use Phoenix.Channel

  def join("AIgame:lobby", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("engine_output", %{"id" => id, "output" => outpu} , socket) do
    Logger.info("Received engine output for ID: #{id}")

    if output == "OK" do
        IO.put("All is well cooked and done, yay")
    end
    # Handle incoming messages from the engine
    {:noreply, socket}
  end

  def handle_in("make_move", %{"move" => move} = payload, socket) do
    # Handle incoming move event
    {:noreply, socket}
  end
end
