defmodule MyProjectWeb.DashboardLive.Index do
  use MyProjectWeb, :live_view

  alias MyProject.Dashboards
  alias MyProject.Dashboards.Dashboard

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, :show_admin_submenu, false)
    {:ok, stream(socket, :dashboards, Dashboards.list_dashboards())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Dashboard")
    |> assign(:dashboard, Dashboards.get_dashboard!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Dashboard")
    |> assign(:dashboard, %Dashboard{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Dashboards")
    |> assign(:dashboard, nil)
  end

  @impl true
  def handle_info({MyProjectWeb.DashboardLive.FormComponent, {:saved, dashboard}}, socket) do
    {:noreply, stream_insert(socket, :dashboards, dashboard)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    dashboard = Dashboards.get_dashboard!(id)
    {:ok, _} = Dashboards.delete_dashboard(dashboard)

    {:noreply, stream_delete(socket, :dashboards, dashboard)}
  end

  @impl true
  def handle_event("toggle_admin_submenu", _params, socket) do
    {:noreply, assign(socket, show_admin_submenu: !socket.assigns[:show_admin_submenu])}
  end
end
