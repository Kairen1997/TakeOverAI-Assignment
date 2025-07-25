defmodule MyProjectWeb.DashboardLive.FormComponent do
  use MyProjectWeb, :live_component

  alias MyProject.Dashboards

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage dashboard records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="dashboard-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="text" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Dashboard</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{dashboard: dashboard} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Dashboards.change_dashboard(dashboard))
     end)}
  end

  @impl true
  def handle_event("validate", %{"dashboard" => dashboard_params}, socket) do
    changeset = Dashboards.change_dashboard(socket.assigns.dashboard, dashboard_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"dashboard" => dashboard_params}, socket) do
    save_dashboard(socket, socket.assigns.action, dashboard_params)
  end

  defp save_dashboard(socket, :edit, dashboard_params) do
    case Dashboards.update_dashboard(socket.assigns.dashboard, dashboard_params) do
      {:ok, dashboard} ->
        notify_parent({:saved, dashboard})

        {:noreply,
         socket
         |> put_flash(:info, "Dashboard updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_dashboard(socket, :new, dashboard_params) do
    case Dashboards.create_dashboard(dashboard_params) do
      {:ok, dashboard} ->
        notify_parent({:saved, dashboard})

        {:noreply,
         socket
         |> put_flash(:info, "Dashboard created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
