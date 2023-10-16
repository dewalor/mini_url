defmodule MiniUrlWeb.UrlLive.FormComponent do
  use MiniUrlWeb, :live_component

  alias MiniUrl.Urls

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Submit an url for shortening.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="url-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:original]} type="text" label="original url" placeholder="example.com/"/>
        <.input style="display:none" field={@form[:short]} />
        <.input style="display:none" field={@form[:visits]} type="number" />
        <:actions>
          <.button phx-disable-with="Saving...">Submit</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{url: url} = assigns, socket) do
    changeset = Urls.change_url(url)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"url" => url_params}, socket) do
    changeset =
      socket.assigns.url
      |> Urls.change_url(url_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"url" => url_params}, socket) do
    save_url(socket, socket.assigns.action, url_params)
  end

  defp save_url(socket, :edit, url_params) do
    case Urls.update_url(socket.assigns.url, url_params) do
      {:ok, url} ->
        notify_parent({:saved, url})

        {:noreply,
         socket
         |> put_flash(:info, "Url updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_url(socket, :new, url_params) do

    case Urls.create_url(url_params) do
      {:ok, url} ->
        notify_parent({:saved, url})

        {:noreply,
         socket
         |> put_flash(:info, "Url created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
