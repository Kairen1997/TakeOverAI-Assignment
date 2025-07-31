defmodule MyProjectWeb.DashboardLive.Index do
  use MyProjectWeb, :live_view

  alias MyProject.Dashboards
  alias MyProject.Dashboards.Dashboard

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:show_admin_submenu, false)
      |> assign(:current_path, "Dashboard")
      |> assign(:filter_status, nil)
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Dashboard")
    |> assign(:dashboard, Dashboards.get_dashboard!(id))
    |> assign(:current_path, "Dashboard > Edit")
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Dashboard")
    |> assign(:dashboard, %Dashboard{})
    |> assign(:current_path, "Dashboard > New")
  end


  defp apply_action(socket, :index, params) do
    page = String.to_integer(Map.get(params, "page", "1"))
    per_page = String.to_integer(Map.get(params, "per_page", "5"))
    raw_status = Map.get(params, "status", socket.assigns[:filter_status])
    filter_status = if raw_status == "", do: nil, else: raw_status
    search_query = Map.get(params, "query", socket.assigns[:search_query])

    pagination = Dashboards.list_dashboards_paginated(%{
      page: page,
      per_page: per_page,
      status: filter_status,
      query: search_query
    })

    socket
    |> assign(:page_title, "Listing Dashboards")
    |> assign(:dashboard, nil)
    |> assign(:pagination, pagination)
    |> assign(:current_path, "Dashboard")
    |> assign(:filter_status, filter_status)
    |> assign(:search_query, search_query)
    |> stream(:dashboards, pagination.entries, reset: true)
  end

  @impl true
  def handle_info({MyProjectWeb.DashboardLive.FormComponent, {:saved, _dashboard}}, socket) do

    page = 1
    per_page = 5
    filter_status = socket.assigns[:filter_status]
    search_query = socket.assigns[:search_query]

    pagination = Dashboards.list_dashboards_paginated(%{
      page: page,
      per_page: per_page,
      status: filter_status,
      query: search_query
    })

    socket =
      socket
      |> assign(:pagination, pagination)
      |> stream(:dashboards, pagination.entries, reset: true)

    {:noreply, socket}
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

  @impl true
  def handle_event("update_path", %{"path" => path}, socket) do
    {:noreply, assign(socket, current_path: path)}
  end

  @impl true
  def handle_event("filter", %{"status" => status}, socket) do
    status = if status == "", do: nil, else: status
    {:noreply, push_patch(socket, to: ~p"/dashboards?#{%{status: status, page: 1}}")}
  end

  @impl true
  def handle_event("search", %{"_target" => _, "query" => query}, socket) do
    search_query = if query == "", do: nil, else: query

    {:noreply,
    push_patch(socket,
      to:
        ~p"/dashboards?#{%{
          status: socket.assigns.filter_status,
          query: search_query,
          page: 1
        }}"
    )}
  end
end
