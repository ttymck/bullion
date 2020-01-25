defmodule BullionWeb.PlayerController do
  use BullionWeb, :controller

  alias Bullion.Repo
  alias Bullion.Game
  alias BullionWeb.Endpoint
  alias Bullion.Player
  alias Bullion.CashOut
  alias BullionWeb.Router.Helpers, as: Routes

  def add_buyin(conn, %{"player_id" => player_id, "game_id" => game_id}) do
    Player
    |> Repo.get_by(id: player_id)
    |> case do
        player -> 
          add_buyin(player)
          |> case do 
            {:ok , _} -> 
              conn
              |> redirect(to: Routes.game_path(conn, :view_game, shortcode: Game.shortcode_for_id(game_id)))
            {:error, error} -> 
              conn
              |> put_flash(:info, "unable to add buyin to player: #{error}")
              |> redirect(to: Routes.game_path(conn, :view_game, shortcode: Game.shortcode_for_id(game_id)))
          end
        nil -> 
          conn
          |> put_flash(:info, "unable to add buyin to player")
          |> redirect(to: Routes.game_path(conn, :view_game, shortcode: Game.shortcode_for_id(game_id)))
      end
  end

  def add_buyin(%Player{} = player) do
    player
    |> Player.changeset(%{buyin_count: player.buyin_count + 1})
    |> Repo.update
  end

  def cash_out(conn, %{"player_id" => player_id, "chip_count" => chip_count}) do
    Player
    |> Repo.get_by(id: player_id)
    |> case do
      player ->
        %CashOut{}
        |> CashOut.changeset(%{chip_count: chip_count, player_id: player_id})
        |> Repo.insert
        conn 
        |> redirect(to: Routes.game_path(conn, :view_game, shortcode: Game.shortcode_for_id(player.game_id)))
      nil ->
        conn 
        |> put_flash(:info, "unable to cash out player")
        |> redirect("/")
    end
  end

  def cash_out(conn, %{"player_id" => player_id}) do
    Player
    |> Repo.get_by(id: player_id)
    |> case do
      player ->
        conn
        |> assign(:player, player)
        |> render("cash_out.html")
      nil ->
        conn
        |> put_flash(:info, "unable to cash out player")
        |> redirect("/")
    end
  end
end