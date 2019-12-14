defmodule BullionWeb.GameController do
  use BullionWeb, :controller

  def new(conn, _params) do
    render(conn, "new_game.html")
  end

  def lookup(conn, %{"shortcode" => shortcode}) do
    render(conn, "view_game.html", shortcode: shortcode)
  end
end
