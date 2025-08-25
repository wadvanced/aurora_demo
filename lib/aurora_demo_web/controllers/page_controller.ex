defmodule AuroraDemoWeb.PageController do
  use AuroraDemoWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
