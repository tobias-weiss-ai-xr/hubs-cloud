defmodule Ret.Repo.Migrations.CreateHubWorksheets do
  use Ecto.Migration

  def change do
    create table(:hub_worksheets, primary_key: false) do
      add :worksheet_id, :bigint, default: fragment("ret0.next_id()"), primary_key: true
      add :hub_id, references(:hubs, column: :hub_id, on_delete: :delete_all), null: false
      add :title, :text, null: false
      add :steps, :map, default: fragment("'[]'::jsonb"), null: false
      add :active, :boolean, default: true
      timestamps()
    end

    create index(:hub_worksheets, [:hub_id])
  end
end
