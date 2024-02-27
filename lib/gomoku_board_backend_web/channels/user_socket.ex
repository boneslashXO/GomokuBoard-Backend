defmodule GomokuBoardBackendWeb.UserSocket do
  use Phoenix.Socket

  channel "AIgame:lobby", GomokuBoardBackendWeb.AIGameChannel

  # Other socket definitions...
end
