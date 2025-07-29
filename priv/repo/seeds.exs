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

# Create some sample dashboards
dashboards = [
  %{
    title: "Sales Dashboard",
    description: "Track sales performance and revenue metrics"
  },
  %{
    title: "User Analytics",
    description: "Monitor user engagement and behavior patterns"
  },
  %{
    title: "System Health",
    description: "Monitor system performance and uptime"
  },
  %{
    title: "Marketing Campaigns",
    description: "Track marketing campaign effectiveness"
  },
  %{
    title: "Customer Support",
    description: "Monitor support tickets and response times"
  }
]

Enum.each(dashboards, fn dashboard_attrs ->
  case Dashboards.create_dashboard(dashboard_attrs) do
    {:ok, dashboard} ->
      IO.puts("Created dashboard: #{dashboard.title}")
    {:error, changeset} ->
      IO.puts("Failed to create dashboard: #{inspect(changeset.errors)}")
  end
end)
