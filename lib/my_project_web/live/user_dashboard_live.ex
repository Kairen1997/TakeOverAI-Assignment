defmodule MyProjectWeb.UserDashboardLive do
  use MyProjectWeb, :live_view

  on_mount {MyProjectWeb.UserAuth, :mount_current_user}

  def render(assigns) do
    ~H"""
    <div class="p-6">
      <h1 class="text-2xl font-bold mb-4">User Dashboard</h1>

      <p>Welcome, regular user!</p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, current_path: "Dashboard")}
  end

  def handle_event("update_path", %{"path" => path}, socket) do
    {:noreply, assign(socket, current_path: path)}
  end
end
