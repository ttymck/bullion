defmodule BullionWeb.GameController do
  use BullionWeb, :controller

  alias Bullion.Repo
  alias Bullion.Game
  alias BullionWeb.Endpoint
  alias Bullion.Player
  alias BullionWeb.Router.Helpers, as: Routes
  import Ecto.Query

  def new(conn, _params) do
    conn
    |> render("new_game.html")
  end

  def create(conn, %{"new_game" => new_game}) do
    Game.changeset(%Game{}, new_game) 
      |> Repo.insert 
      |> case do
        {:ok, game} -> 
          conn 
          |> fn c ->
            redirect(c, to: Routes.game_path(Endpoint, :list_players, admin_shortcode: Game.put_shortcodes(game).admin_shortcode)) 
          end.()
        {:error, error} -> 
          conn
          |> put_flash(:info, "unable to create new game: #{error}")
          |> redirect(to: "/")
      end
  end

  def list_players(conn, %{"admin_shortcode" => admin_shortcode}) do
    case get_game_for_admin(admin_shortcode) do
       {:error, _} -> conn
         |> put_flash(:info, "Game not found for shortcode '#{admin_shortcode}'")
         |> redirect(to: "/")
       {:ok, game} -> list_players(conn, game)
     end
  end

  def list_players(conn, game = %Game{}) do
     conn  
     |> assign(:game, game)
     |> render("list_players.html")
  end

  def add_player(conn, %{"player" => %{"game_id" => game_id, "name" => name}}) do  
    %Player{}
    |> Player.changeset(%{name: name, game_id: game_id, buyin_count: 0})
    |> Repo.insert

    conn
    |> redirect(to: BullionWeb.Router.Helpers.game_path(Endpoint, :list_players, admin_shortcode: Game.admin_shortcode_for_id(game_id)))
  end

  defp get_game_by_id(game_id) do
    Game 
    |> where([game], game.id == ^game_id)
    |> join(:left, [g], _ in assoc(g, :players))
    |> join(:left, [_, players], _ in assoc(players, :cashouts))
    |> preload([game, players, cashouts], [players: {players, cashouts: cashouts}])
    |> Repo.one
    |> case do
        nil -> {:error, :game_not_found}
        game -> {:ok, Game.put_shortcode(game)}
    end
  end

 defp get_game_by_shortcode(shortcode) do
    Game.id_for_shortcode(shortcode)
    |> case do 
      {:ok, [id]} -> get_game_by_id(id)
      _ -> {:error, :game_not_found}
    end
  end

  defp get_game_for_admin(admin_shortcode) do
    Game.id_for_admin_shortcode(admin_shortcode)
    |> case do
        {:ok, [id]} -> 
          get_game_by_id(id)
          |> case do
            {:ok, game} -> {:ok, Game.put_admin_shortcode(game)}
            other -> other
          end
        _ -> {:error, :game_not_found}
    end
  end

  def view_game(conn, %{"admin_shortcode" => admin_shortcode}) do
    case get_game_for_admin(admin_shortcode) do
      {:ok, game} -> conn |> assign(:game, game) |> render("admin_game.html", game: game)
      {:error, _} -> conn |> put_flash(:info, "Game not found for shortcode '#{admin_shortcode}'") |> redirect(to: "/")
    end
  end

  def view_game(conn, %{"shortcode" => shortcode}) do
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
