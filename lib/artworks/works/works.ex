defmodule Artworks.Works do
  @moduledoc """
  Manages artworks data

  See Work module for more details
  """
  alias Artworks.Works.Work

  @doc """
  Retrieves image links for the givent work type
  """
  def get_links(work_type), do:  Work.get_links(work_type)

  @doc """
  Retrieves all different work types
  """
  def get_work_types(), do: Work.get_work_types()
end