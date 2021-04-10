defmodule ArtworksWeb.Locale do
  @moduledoc """
    A plug to handle locale

    `fallback_locale` and `valid_locales` should be found in config.exs

    Locale is retrieve from url:
      - "/" -> locale will be the fallback one
      - "/?locale=xx" where `xx`is the deisired locale: will set the xx locale
      if it's partt of the valid locales
  """
  import Plug.Conn

  @valid_locales Application.get_env(:artworks, :valid_locales)
  @fallback_locale Application.get_env(:artworks, :fallback_locale)

  @doc """
    Callback implementation for `Plug.init/1`
  """
  def init(opts) do
    opts
  end

  @doc """
    Callback implementation for `Plug.call/2`
  """
  def call(conn, _opts) do
    _locale =
      get_locale_from_conn(conn)
      |> validate()

    # For now, site is exclusively in french
    locale = @fallback_locale

    Gettext.put_locale(ArtworksWeb.Gettext, locale)

    conn
    |> put_session(:locale, locale)
  end

  defp get_locale_from_conn(conn) do
    case conn.params["locale"] || get_session(conn, :locale) do
      nil -> @fallback_locale
      locale -> locale
    end
    |> IO.inspect()
  end

  defp validate(locale) do
    case Enum.member?(@valid_locales, locale) do
      true -> locale
      false -> @fallback_locale
    end
  end
end
