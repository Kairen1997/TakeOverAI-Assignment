defmodule MyProjectWeb.UserProfileLive do
  use MyProjectWeb, :live_view

  alias MyProject.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Update Profile
      <:subtitle>Update your personal information and account settings</:subtitle>
    </.header>

    <div class="space-y-12 divide-y">
      <!-- Profile Information -->
      <div>
        <.simple_form
          for={@profile_form}
          id="profile_form"
          phx-submit="update_profile"
          phx-change="validate_profile"
        >
          <.input field={@profile_form[:full_name]} type="text" label="Full Name" required />
          <.input field={@profile_form[:ic_number]} type="text" label="IC Number" required placeholder="12 digits" />
          <.input field={@profile_form[:phone_number]} type="tel" label="Phone Number" required />

          <.input
            field={@profile_form[:gender]}
            type="select"
            label="Gender"
            required
            options={[{"Male", "male"}, {"Female", "female"}, {"Other", "other"}]}
          />

          <.input field={@profile_form[:birthdate]} type="date" label="Birth Date" required />
          <.input field={@profile_form[:address]} type="textarea" label="Address" required />
          <.input field={@profile_form[:monthly_income]} type="number" label="Monthly Income (RM)" required step="0.01" />

          <:actions>
            <.button phx-disable-with="Updating...">Update Profile</.button>
          </:actions>
        </.simple_form>
      </div>

      <!-- Password Change Section -->
      <div>
        <.simple_form
          for={@password_form}
          id="password_form"
          action={~p"/users/log_in?_action=password_updated"}
          method="post"
          phx-change="validate_password"
          phx-submit="update_password"
          phx-trigger-action={@trigger_submit}
        >
          <input
            name={@password_form[:email].name}
            type="hidden"
            id="hidden_user_email"
            value={@current_email}
          />
          <.input field={@password_form[:password]} type="password" label="New password" required />
          <.input
            field={@password_form[:password_confirmation]}
            type="password"
            label="Confirm new password"
          />
          <.input
            field={@password_form[:current_password]}
            name="current_password"
            type="password"
            label="Current password"
            id="current_password_for_password"
            value={@current_password}
            required
          />
          <:actions>
            <.button phx-disable-with="Changing...">Change Password</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    profile_changeset = Accounts.change_user_profile(user)
    password_changeset = Accounts.change_user_password(user)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:profile_form, to_form(profile_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate_profile", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_profile(socket.assigns.current_user, user_params)
    {:noreply, assign(socket, profile_form: to_form(Map.put(changeset, :action, :validate)))}
  end

  @impl true
  def handle_event("update_profile", %{"user" => user_params}, socket) do
    case Accounts.update_user_profile(socket.assigns.current_user, user_params) do
      {:ok, user} ->
        changeset = Accounts.change_user_profile(user)
        {:noreply,
         socket
         |> put_flash(:info, "Profile updated successfully.")
         |> assign(profile_form: to_form(changeset))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, profile_form: to_form(changeset))}
    end
  end

  @impl true
  def handle_event("validate_password", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_password(socket.assigns.current_user, user_params)
    {:noreply, assign(socket, password_form: to_form(Map.put(changeset, :action, :validate)))}
  end

  @impl true
  def handle_event("update_password", %{"user" => user_params}, socket) do
    case Accounts.update_user_password(
           socket.assigns.current_user,
           user_params["current_password"],
           user_params
         ) do
      {:ok, user} ->
        password_changeset = Accounts.change_user_password(user)
        {:noreply,
         socket
         |> put_flash(:info, "Password updated successfully.")
         |> assign(password_form: to_form(password_changeset))
         |> assign(trigger_submit: true)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end
end
