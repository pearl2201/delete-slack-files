defmodule SlackTool.Repo do
  use Ecto.Repo,
    otp_app: :slack_tool,
    adapter: Ecto.Adapters.Postgres
end
