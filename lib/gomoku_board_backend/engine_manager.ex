defmodule GomokuBoardBackend.EngineManager do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_) do
    initial_state = %{
      engine_port: nil,
      command_type: nil
    }
    {:ok, initial_state}
  end

  # Public APIs to interact with the game engine
  def start_engine_and_setup_board(command), do: GenServer.call(__MODULE__, {:start_engine_and_setup_board, command})
  def analyse(command), do: GenServer.call(__MODULE__, {:analyse, command})
  def stop_engine(command), do: GenServer.call(__MODULE__, {:stop_engine, command})

  # Handle calls
  def handle_call({action, command}, _from, state) do
    case action do
      :start_engine_and_setup_board -> start_engine(command, state)
      :analyse -> analyse_position(command, state)
      :stop_engine -> stop_engine(command, state)
    end
  end

  defp start_engine(command, state) do
    engine_path = System.get_env("ENGINE_PATH") || "path/to/pbrain.exe"
    port = Port.open({:spawn_executable, engine_path}, [:binary, :exit_status, :use_stdio, :stderr_to_stdout])
    Port.command(port, command)
    {:reply, :ok, update_state(state, port, "start_ai")}
  end

  defp analyse_position(command, state) do
    handle_engine_command(state, command, "analyze_position")
  end

  defp stop_engine(command, state) do
    handle_engine_command(state, command, "stop_ai")
  end

  defp handle_engine_command(state, command, type) do
    port = Map.get(state, :engine_port)
    if is_nil(port), do: {:reply, {:error, :engine_not_started}, state}, else: command_to_port(port, command, type, state)
  end

  defp command_to_port(port, command, type, state) do
    Port.command(port, command)
    {:reply, :ok, update_state(state, port, type)}
  end

  defp update_state(state, port, type) do
    state
    |> Map.put(:engine_port, port)
    |> Map.put(:command_type, type)
  end

  def handle_info({port, {:data, data}}, state) do
    if port == Map.get(state, :engine_port), do: broadcast_engine_output(data, Map.get(state, :command_type))
    {:noreply, state}
  end

  defp broadcast_engine_output(data, command_type) do
    parsed_data = String.trim(data)
    GomokuBoardBackendWeb.Endpoint.broadcast("AIgame:lobby", "engine_output", %{
      output: parsed_data,
      commandType: command_type
    })
  end
end
