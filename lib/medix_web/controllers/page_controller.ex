defmodule MedixWeb.PageController do
  use MedixWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end
  def song(conn, _opts) do
    file = File.read!(File.cwd!() <> "/assets/audio/q_1.m4a")

    conn
    |> put_resp_content_type("audio/x-m4a")
    |> put_resp_header("Content-disposition", "attachment; filename=\"q_1.m4a\"")
    |> send_resp(200, file)
  end
end
