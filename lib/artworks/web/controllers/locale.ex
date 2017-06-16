defmodule Artworks.Web.Locale do
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
  @fallback_locales Application.get_env(:artworks, :fallback_locale)

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
    language =
    case conn.params["locale"] || get_session(conn, :locale) do
      nil     -> @fallback_locales
      locale  -> locale
    end

    locale =
    case Enum.member?(@valid_locales, language) do
      true -> language
      false -> @fallback_locales
    end

    Gettext.put_locale(Artworks.Web.Gettext, locale)
    conn
    |> put_session(:locale, locale)
  end

end