defmodule ReactTestWeb.PageController do
  use ReactTestWeb, :controller

  def index(conn, _params) do
    html conn, File.read!("apps/react_test_web/priv/static/index.html")
  end
end
