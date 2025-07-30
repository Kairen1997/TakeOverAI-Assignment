defmodule MyProject.Repo.Migrations.AddStatusToDashboards do
  use Ecto.Migration

  def change do
    alter table(:dashboards) do
      add :status, :string, default: "active", null: false
    end
  end
end
