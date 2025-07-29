defmodule MyProjectWeb.DashboardLive.Show do
  use MyProjectWeb, :live_view

  alias MyProject.Dashboards

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, :show_admin_submenu, false)
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:dashboard, Dashboards.get_dashboard!(id))}
  end

  defp page_title(:show), do: "Show Dashboard"
  defp page_title(:edit), do: "Edit Dashboard"

  @impl true
  def handle_event("toggle_admin_submenu", _params, socket) do
    {:noreply, assign(socket, show_admin_submenu: !socket.assigns[:show_admin_submenu])}
  end
end
