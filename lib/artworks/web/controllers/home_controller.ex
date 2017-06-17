defmodule Artworks.Web.HomeController do
  use Artworks.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
