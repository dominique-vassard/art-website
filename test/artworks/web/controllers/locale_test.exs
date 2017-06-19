defmodule Artworks.Web.LocaleTest do
  use Artworks.Web.ConnCase
  alias Artworks.Web.Router

  @valid_locales Application.get_env(:artworks, :valid_locales)
  @fallback_locale Application.get_env(:artworks, :fallback_locale)
  @invalid_locale "xx"

  setup %{conn: conn} do
    conn = conn
    |> bypass_through(Router, :browser)

    {:ok, %{conn: conn}}
  end

  test "locale set to fr when access /", %{conn: conn} do
    get conn, "/"

    assert Gettext.get_locale(Artworks.Web.Gettext) == @fallback_locale
  end

  test "set locale via ?locale=xx", %{conn: conn} do
    @valid_locales
    |> Enum.each(fn locale -> test_locale(locale, conn) end)
  end

  test "invalid locale fall back to default locale", %{conn: conn} do
    conn = conn
    |> get("/?locale=" <> @invalid_locale)

    assert Gettext.get_locale(Artworks.Web.Gettext) == @fallback_locale
    assert get_session(conn, :locale) == @fallback_locale
  end

  def test_locale(locale, conn) do
    conn = conn
    |> get("/?locale=" <> locale)

    assert Gettext.get_locale(Artworks.Web.Gettext) == locale
    assert get_session(conn, :locale) == locale
  end
end