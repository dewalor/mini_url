defmodule MiniUrlWeb.DownloadController do
  use MiniUrlWeb, :controller
  alias MiniUrl.Urls

  def create(conn, _params) do
    csv_data = csv_content(Urls.list_urls(), [:original, :short, :visits])
    conn
      |> put_resp_content_type("text/csv")
      |> put_resp_header("content-disposition", "attachment; filename=\"export.csv\"")
      |> put_root_layout(false)
      |> send_resp(200, csv_data)
  end

  defp csv_content(urls, fields) do
     urls
      |> Enum.map(fn url ->
        url
        |> Map.from_struct()
        |> Map.take([])
        |> Map.merge( Map.take(url, fields) )
        |> Map.values()
      end)
      |> CSV.encode()
      |> Enum.to_list()
      |> to_string()
  end
end
