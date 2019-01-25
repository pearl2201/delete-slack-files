defmodule SlackToolWeb.SlackController do
  use SlackToolWeb, :controller
  alias SlackToolWeb.SlackHandler

  def index(conn, %{"challenge" => challenge}) do
    text(conn, "#{challenge}")
  end

  def index(conn, _params) do
    Task.Supervisor.async_nolink(SlackTool.TaskSupervisor, fn ->
      evt = _params["event"]

      if evt != nil do
        SlackHandler.handler_event(evt)
      end

      cmd = _params["command"]

      if cmd != nil do
        SlackHandler.handler_command(_params)
      end
    end)

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "")
  end
end
