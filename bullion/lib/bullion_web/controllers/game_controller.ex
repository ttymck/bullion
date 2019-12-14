defmodule BullionWeb.GameController do
  use BullionWeb, :controller

  alias Bullion.Repo
  alias Bullion.Game

  def new(conn, _params) do
    new_game = %Game{
      shortcode: "abc123", buyin_dollars: 20, buyin_chips: 100
    } |> Repo.insert
    conn
    |> assign(:game, new_game)
    |> render("new_game.html")
  end

 defp get_game_by_shortcode(shortcode) do
    Game 
    |> Repo.get_by(shortcode: shortcode)
    |> case do
        nil -> {:error, :game_not_found}
        user -> {:ok, user}
    end
  end

  def lookup(conn, %{"shortcode" => shortcode}) do
    case get_game_by_shortcode(shortcode) do
      {:error, _} -> conn
        |> put_flash(:info, "Game not found for shortcode '#{shortcode}'")
        |> redirect(to: "/")
      {:ok, game} -> conn
        |> assign(:game, game)
        |> render("view_game.html", game: game)
    end
  end
end
