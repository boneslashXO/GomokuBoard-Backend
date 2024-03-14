defmodule GomokuBoardBackendWeb.UserSocket do
  use Phoenix.Socket

  channel "AIgame:lobby", GomokuBoardBackendWeb.AIGameChannel

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
  # Other socket definitions...
end
