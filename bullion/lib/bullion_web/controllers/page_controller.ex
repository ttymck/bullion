defmodule BullionWeb.PageController do
  use BullionWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
