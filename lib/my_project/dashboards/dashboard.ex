defmodule MyProject.Dashboards.Dashboard do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dashboards" do
    field :description, :string
    field :status, :string, default: "active"
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(dashboard, attrs) do
    dashboard
    |> cast(attrs, [:title, :description, :status])
    |> validate_required([:title, :description, :status])
    |> validate_inclusion(:status, ["active", "inactive"])
  end
end
