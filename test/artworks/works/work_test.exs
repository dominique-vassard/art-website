defmodule ArtWorks.Works.WorkTest do
  use Artworks.DataCase, async: true

  alias Artworks.Works.Work

  test "get work types" do
    assert length(Work.get_work_types) >= 1
  end

  test "get links for all valid types" do
    Work.get_work_types()
    |> Enum.each(&test_type/1)
  end

  test "try not get non-existing type returns an {:error, reason}" do
    invalid = "invalid655xxxs"
    {res, reason} = Work.get_links(invalid)

    assert res == :error
    assert reason == "#{invalid} does not exist."
  end

  def test_type(work_type) do
    {res, list} = Work.get_links(work_type)

    assert res == :ok
    assert length(list) >= 0
  end
end