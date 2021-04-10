defmodule ArtworksWeb.PageController do
  use ArtworksWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
