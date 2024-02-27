defmodule GomokuBoardBackendWeb.AIGameController do
  use GomokuBoardBackendWeb, :controller

  def create(conn, %{"start" => move_params}) do
    # Implement your logic here
    json(conn, %{response: "Your logic result here"})
  end
end
