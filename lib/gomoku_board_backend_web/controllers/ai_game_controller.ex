defmodule GomokuBoardBackendWeb.AIGameController do
  use GomokuBoardBackendWeb, :controller

  def create(conn) do
    id = UUID.uuid4()
    engine_path = System.get_env("ENGINE_PATH")
    params = ["info rule 1\n", "START 15 \n"]

    case System.cmd(engine_path, params) do
      {:ok, output} ->
        Logger.info("This is an informational message.")
        # Handle successful output
        IO.puts("Engine output: #{output}")

        GomokuBoardBackendWeb.Endpoint.broadcast("game:lobby", "engine_output", %{
          id: id,
          output: output
        })

      {:error, reason} ->
        # Handle error
        IO.puts("Error running engine: #{reason}")
    end
  end
end
