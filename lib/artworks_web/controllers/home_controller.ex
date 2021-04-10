defmodule ArtworksWeb.HomeController do
  use ArtworksWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def contact(conn, _params) do
    render(conn, "contact.html")
  end

  def biography(conn, _params) do
    render(conn, "biography.html")
  end
end
