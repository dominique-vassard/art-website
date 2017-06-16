defmodule Artworks.Web.LocaleTest do
  use Artworks.Web.ConnCase

  @valid_languages Application.get_env(:artworks, :valid_languages)
  @fallback_language Application.get_env(:artworks, :fallback_language)
  @invalid_locale "xx"

  test "locale set to fr when access /", %{conn: conn} do
    get conn, "/"

    assert Gettext.get_locale(Artworks.Web.Gettext) == @fallback_language
  end

  test "set locale via ?locale=xx", %{conn: conn} do
    @valid_languages
    |> Enum.each(fn locale -> test_locale(locale, conn) end)
  end

  test "invalid locale fall back to default locale", %{conn: conn} do
    get conn, "/?locale=" <> @invalid_locale

    assert Gettext.get_locale(Artworks.Web.Gettext) == @fallback_language
  end

  def test_locale(locale, conn) do
    get conn, "/?locale=" <> locale

    assert Gettext.get_locale(Artworks.Web.Gettext) == locale
  end
end