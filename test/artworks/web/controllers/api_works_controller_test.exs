defmodule ArtWorks.Web.ApiWorksControllerTest do
  use Artworks.Web.ConnCase, async: true

  test "/api/works/get_list success for a valid work type", %{conn: conn} do
    conn = get conn, "/api/works/get_list/drawings"
    %{"result" => result, "links" => links} = json_response(conn, 200)

    assert result == "success"
    assert length(links) >= 1
  end

  test "/api/works/get_list error for a valid work type", %{conn: conn} do
    invalid = "invalid_typess"
    conn = get conn, "/api/works/get_list/" <> invalid
    %{"result" => result, "reason" => reason} = json_response(conn, 200)

    assert result == "error"
    assert reason == "#{invalid} does not exist."
  end
end