defmodule Artworks.Web.HomeControllerTest do
  use Artworks.Web.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Lorem Ipsum"
  end
end
