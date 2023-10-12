defmodule DBListenerWeb.Router do
  use DBListenerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", DBListenerWeb do
    pipe_through :api
  end
end
