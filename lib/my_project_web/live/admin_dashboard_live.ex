defmodule MyProjectWeb.AdminDashboardLive do
  use MyProjectWeb, :live_view

  on_mount {MyProjectWeb.UserAuth, :mount_current_user}

  def render(assigns) do
    ~H"""
    <div class="p-6">
      <h1 class="text-2xl font-bold mb-4">Admin Dashboard</h1>

      <p>Welcome, admin!</p>
    </div>
    """
  end

  def mount(_params, session, socket) do
    show_admin_submenu = session["show_admin_submenu"] || false
    {:ok, assign(socket, show_admin_submenu: show_admin_submenu)}
  end

    def handle_event("toggle_admin_submenu", _params, socket) do
    {:noreply, assign(socket, show_admin_submenu: !socket.assigns.show_admin_submenu)}
  end
end
