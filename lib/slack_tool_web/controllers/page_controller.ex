defmodule SlackToolWeb.PageController do
  use SlackToolWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
