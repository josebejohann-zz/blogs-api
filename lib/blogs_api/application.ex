defmodule BlogsAPI.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      BlogsAPI.Repo,
      # Start the Telemetry supervisor
      BlogsAPIWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: BlogsAPI.PubSub},
      # Start the Endpoint (http/https)
      BlogsAPIWeb.Endpoint
      # Start a worker by calling: BlogsAPI.Worker.start_link(arg)
      # {BlogsAPI.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BlogsAPI.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BlogsAPIWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
