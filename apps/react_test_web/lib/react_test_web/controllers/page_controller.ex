defmodule ReactTestWeb.PageController do
  use ReactTestWeb, :controller

  def index(conn, _params) do
    if System.get_env("SERVE_ON_ROOT") == "true" do
      html conn, File.read!("/apps/react_test_web/priv/static/index.html")
    else
      html conn, File.read!("apps/react_test_web/priv/static/index.html")
    end
  end
end
