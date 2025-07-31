defmodule MyProject.Repo.Migrations.AddProfileFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :full_name, :string
      add :ic_number, :string
      add :phone_number, :string
      add :gender, :string
      add :birthdate, :date
      add :address, :text
      add :monthly_income, :decimal, precision: 10, scale: 2
    end
  end
end
