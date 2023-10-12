defmodule MiniUrlWeb.UrlLive.Show do
  use MiniUrlWeb, :live_view

  alias MiniUrl.Urls

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:url, Urls.get_url!(id))}
  end

  defp page_title(:show), do: "Show Url"
  defp page_title(:edit), do: "Edit Url"
end
