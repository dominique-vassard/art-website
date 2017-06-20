defmodule Artworks.Web.Router do
  use Artworks.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Artworks.Web.Locale
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Artworks.Web do
    pipe_through :browser # Use the default browser stack

    get "/", HomeController, :index
    get "/contact", HomeController, :contact
    get "/biography", HomeController, :biography
    get "/works", WorksController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", Artworks.Web do
    pipe_through :api

    get "/works/get_list/:work_type", ApiWorksController, :get_list
  end
end
