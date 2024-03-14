defmodule GomokuBoardBackend.EngineManager do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

def init(_) do
  # Initialize state with default values for engine_port and command_type
  initial_state = %{
    engine_port: nil,
    command_type: nil
  }
  {:ok, initial_state}
end

  # Public API to start the engine and setup the board
  def start_engine_and_setup_board(command) do
    GenServer.call(__MODULE__, {:start_engine_and_setup_board, command})
  end

  #Public API to analyse with the engine
  def analyse(command) do
    #IO.puts(command)
    GenServer.call(__MODULE__, {:analyse, command})
  end

   # Public API to stop the engine
  def stop_engine(command) do
    GenServer.call(__MODULE__, {:stop_engine, command})
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

    new_state = Map.put(state, :engine_port, port)
    new_state = Map.put(new_state, :command_type, "start_ai")

    IO.inspect(new_state);

    {:reply, :ok, new_state}
  end


  def handle_call({:analyse, command}, _from, state) do
    # Consider using a more descriptive key like :engine_port
    port = Map.get(state, :engine_port)

    new_state = Map.put(state, :command_type, "analyze_position")

    case port do
      nil ->
        {:reply, {:error, :engine_not_started}, state}

      port ->
        Port.command(port, command)
        {:reply, :ok, new_state}
    end
  end

   def handle_call({:stop_engine, command}, _from, state) do
    # Consider using a more descriptive key like :engine_port
    port = Map.get(state, :engine_port)

    new_state = Map.put(state, :command_type, "stop_ai")

    case port do
      nil ->
        {:reply, {:error, :engine_not_started}, state}

      port ->
        Port.command(port, command)
        {:reply, :ok, new_state}
    end
  end


  def handle_info({port, {:data, data}}, state) do

    current_port = Map.get(state, :engine_port)

    if current_port == port do
    command_type = Map.get(state, :command_type)
    broadcast_engine_output(data, command_type)
    end

    {:noreply, state}
  end

  defp broadcast_engine_output(data, command_type) do
    # Parse or transform data as needed
    parsed_data = String.trim(data)
    # Broadcast the data to the channel
    GomokuBoardBackendWeb.Endpoint.broadcast("AIgame:lobby", "engine_output", %{
      output: parsed_data,
      commandType: command_type
    })
  end
end
