defmodule Ret.Repo.Migrations.CreateUserProgress do
  use Ecto.Migration

  def change do
    create table(:user_progress, primary_key: false) do
      add :user_progress_id, :bigint, default: fragment("ret0.next_id()"), primary_key: true
      add :account_id, references(:accounts, column: :account_id, on_delete: :delete_all)
      add :hub_id, references(:hubs, column: :hub_id, on_delete: :delete_all), null: false
      add :session_id, :text, null: false
      add :element_slug, :text, null: false
      add :element_type, :text, null: false
      add :status, :text, default: "visited", null: false
      add :score, :integer
      add :max_score, :integer
      add :time_spent_ms, :integer, default: 0
      add :visited_count, :integer, default: 1
      add :metadata, :map, default: fragment("'{}'::jsonb")
      timestamps()
    end

    create unique_index(:user_progress, [:account_id, :hub_id, :element_slug])
    create index(:user_progress, [:hub_id])
    create index(:user_progress, [:account_id])
    create index(:user_progress, [:session_id])
  end
end
