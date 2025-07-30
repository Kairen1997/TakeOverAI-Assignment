# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MyProject.Repo.insert!(%MyProject.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Create sample dashboards
alias MyProject.Dashboards

# Create some sample dashboards with different statuses
dashboards = [
  %{
    title: "Sales Dashboard",
    description: "Track sales performance and revenue metrics",
    status: "active"
  },
  %{
    title: "User Analytics",
    description: "Monitor user engagement and behavior patterns",
    status: "active"
  },
  %{
    title: "System Health",
    description: "Monitor system performance and uptime",
    status: "inactive"
  },
  %{
    title: "Marketing Campaigns",
    description: "Track marketing campaign effectiveness",
    status: "active"
  },
  %{
    title: "Customer Support",
    description: "Monitor support tickets and response times",
    status: "inactive"
  },
  %{
    title: "Inventory Management",
    description: "Track inventory levels and stock movements",
    status: "active"
  },
  %{
    title: "Financial Reports",
    description: "Generate financial reports and analytics",
    status: "inactive"
  }
]

Enum.each(dashboards, fn dashboard_attrs ->
  case Dashboards.create_dashboard(dashboard_attrs) do
    {:ok, dashboard} ->
      IO.puts("Created dashboard: #{dashboard.title} (Status: #{dashboard.status})")
    {:error, changeset} ->
      IO.puts("Failed to create dashboard: #{inspect(changeset.errors)}")
  end
end)
