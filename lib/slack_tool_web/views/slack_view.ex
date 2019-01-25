defmodule SlackToolWeb.SlackView do
  use SlackToolWeb, :view

  def render("b64encode.json", %{challenge: challenge}) do
    %{challenge: challenge}
  end
end
