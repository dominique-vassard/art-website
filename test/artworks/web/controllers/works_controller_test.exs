defmodule ArtWorks.Web.WorksControllerTest do
  use Artworks.Web.ConnCase, async: true

  test "/works is powered by Elm", %{conn: conn} do
    conn = get conn, "/works"
    assert html_response(conn, 200) =~ "<div id=\"elm-main\"></div>"
  end
end