defmodule Artworks.Works.Work do
  @moduledoc """
  Work management

  For now, it used file storage and not database.
  Works are images files stored in directory in /priv/static/images/artworks
  """

  # @static_dir Application.app_dir(:artworks, "priv/static")
  @static_dir "priv/static"
  @work_types ~w(drawings paintings)

  @doc """
  Get links for he images of the given type
  """
  def get_links(work_type) when work_type in @work_types do
    dir = "/images/artworks/" <> work_type
    {:ok, filenames} = File.ls(@static_dir <> dir)
    res =
    filenames
      |> Enum.map(&(dir <> "/" <> &1))
      |> Enum.filter(fn fname ->
        Regex.run(~r/[\w-]+[\w-]{32}.(gif|jpg|png)/, fname) == nil
      end)
    {:ok, res}
  end

  def get_links(work_type), do: {:error, "#{work_type} does not exist."}

  @doc """
  Returns the different work types
  """
  def get_work_types(), do: @work_types
end