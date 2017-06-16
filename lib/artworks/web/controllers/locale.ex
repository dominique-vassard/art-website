defmodule Artworks.Web.Locale do
  @moduledoc """
    Locale management for internationalization
  """
  import Plug.Conn

  @valid_languages Application.get_env(:artworks, :valid_languages)
  @fallback_language Application.get_env(:artworks, :fallback_language)

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    language =
    case conn.params["locale"] || get_session(conn, :locale) do
      nil     -> @fallback_language
      locale  -> locale
    end

    locale =
    case Enum.member?(@valid_languages, language) do
      true -> language
      false -> @fallback_language
    end

    Gettext.put_locale(Artworks.Web.Gettext, locale)
    conn
    |> put_session(:locale, locale)
  end

end