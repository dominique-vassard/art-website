defmodule Artworks.Web.LayoutViewTest do
  use Artworks.Web.ConnCase, async: true
  import Phoenix.View

  @valid_locales Application.get_env(:artworks, :valid_locales)

  test "check menu", %{conn: conn} do
    @valid_locales
    |> Enum.each(fn locale -> test_menu(locale, conn) end)
  end

  @doc """
    test menu in the given locale
  """
  def test_menu(locale, conn) do
    Gettext.put_locale(Artworks.Web.Gettext, locale)

    content = render_to_string(Artworks.Web.LayoutView, "menu.html", conn: conn)
    assert String.contains?(content,
      Gettext.dgettext(Artworks.Web.Gettext, "default", "Home")
    )
    assert String.contains?(content,
      Gettext.dgettext(Artworks.Web.Gettext, "default", "Works")
    )
    assert String.contains?(content,
      Gettext.dgettext(Artworks.Web.Gettext, "default", "Biography")
    )
    assert String.contains?(content,
      Gettext.dgettext(Artworks.Web.Gettext, "default", "Contact")
    )
  end
end
