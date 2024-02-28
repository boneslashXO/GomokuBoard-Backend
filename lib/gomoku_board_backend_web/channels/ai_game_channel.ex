defmodule GomokuBoardBackendWeb.AIGameChannel do
  use Phoenix.Channel
  require Logger

  def join("AIgame:lobby", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("engine_output", %{"id" => id, "output" => output} , socket) do
    Logger.info("Received engine output for ID: #{id}")
    IO.puts("ffejfeoj");

    if output == "OK" do
        IO.puts("All is well cooked and done, yay")
         {:reply, %{status: "success", message: output}, socket}
    end
    # Handle incoming messages from the engine
    {:noreply, socket}
  end
end
