defmodule GomokuBoardBackendWeb.TestController do
  use GomokuBoardBackendWeb, :controller

  def index(conn, _params) do
    json(conn, %{message: "API is working!"})
  end
end
