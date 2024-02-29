defmodule GomokuBoardBackend.EngineManager do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_) do
    {:ok, %{}}
  end

  # Public API to start the engine and setup the board
  def start_engine_and_setup_board(command) do
    GenServer.call(__MODULE__, {:start_engine_and_setup_board, command})
  end

  # Handling the call to start the engine and setup the board
  def handle_call({:start_engine_and_setup_board, command}, _from, state) do
    engine_path = System.get_env("ENGINE_PATH") || "path/to/pbrain.exe"

    port =
      Port.open({:spawn_executable, engine_path}, [
        :binary,
        :exit_status,
        :use_stdio,
        :stderr_to_stdout
      ])

    Port.command(port, command)
    {:reply, :ok, Map.put(state, :port, port)}
  end

  def handle_info({port, {:data, data}}, state) do
    # Your existing logic to broadcast engine output
    broadcast_engine_output(data)
    {:noreply, state}
  end

  defp broadcast_engine_output(data) do
    # Parse or transform data as needed
    IO.puts(data)
    parsed_data = String.trim(data)

    # Broadcast the data to the channel
    GomokuBoardBackendWeb.Endpoint.broadcast("AIgame:lobby", "engine_output", %{
      output: parsed_data
    })
  end
end
