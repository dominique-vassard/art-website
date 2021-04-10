defmodule ArtworksWeb.ApiWorksController do
  use ArtworksWeb, :controller

  def get_list(conn, %{"work_type" => work_type}) do
    res =
      case Artworks.Works.get_links(work_type) do
        {:ok, result} -> %{result: "success", links: result}
        {:error, reason} -> %{result: "error", reason: reason}
      end

    json(conn, res)
  end
end
