defmodule GomokuBoardBackendWeb.UserSocket do
  use Phoenix.Socket

  channel "AIgame:lobby", GomokuBoardBackendWeb.AIGameChannel

  def id(_socket), do: nil

  # Other socket definitions...
end
