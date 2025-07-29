defmodule MyProjectWeb.DashboardLive.Show do
  use MyProjectWeb, :live_view

  alias MyProject.Dashboards

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:show_admin_submenu, false)
      |> assign(:current_path, "Dashboard")
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    dashboard = Dashboards.get_dashboard!(id)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:dashboard, dashboard)
     |> assign(:current_path, "Dashboard > #{dashboard.title}")}
  end

  defp page_title(:show), do: "Show Dashboard"
  defp page_title(:edit), do: "Edit Dashboard"

  @impl true
  def handle_event("toggle_admin_submenu", _params, socket) do
    {:noreply, assign(socket, show_admin_submenu: !socket.assigns[:show_admin_submenu])}
  end

  @impl true
  def handle_event("update_path", %{"path" => path}, socket) do
    {:noreply, assign(socket, current_path: path)}
  end
end
