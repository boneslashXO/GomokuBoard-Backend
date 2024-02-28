defmodule GomokuBoardBackendWeb.AIGameController do
  use GomokuBoardBackendWeb, :controller

  require Logger

  def create(conn, _params) do
    engine_path = System.get_env("ENGINE_PATH")
    IO.puts(engine_path);
    # Step 1: Start the engine without parameters
    case System.cmd(engine_path, []) do
      {:ok, _startup_output} ->
        IO.puts("Engine started successfully.")

        # Step 2: Send the combined arguments after a pause
        :timer.sleep(1000) # Pause for 1 second (adjust as needed)
        case System.cmd(engine_path, ["info rule 1\nSTART 15\n"]) do
          {:ok, output} ->
            Logger.info("Command sent to engine successfully.")
            IO.puts("Engine output: #{output}")
            case String.split(output, "\n") do
              [last_message | _] when last_message == "OK" ->
                send_resp(conn, 200, "Engine executed successfully")
              _ ->
                send_resp(conn, 500, "Engine did not respond with 'OK'")
            end

          {:error, reason} ->
            Logger.error("Error sending command to engine: #{reason}")
            send_resp(conn, 500, "Error executing engine command")
        end

      {:error, startup_reason} ->
        Logger.error("Error starting engine: #{startup_reason}")
        send_resp(conn, 500, "Error starting engine")
    end
  end
end
