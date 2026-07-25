defmodule Ret.Repo.Migrations.CreateQuizzesTables do
  use Ecto.Migration

  def change do
    create table(:quizzes, primary_key: false) do
      add :quiz_id, :bigint, default: fragment("ret0.next_id()"), primary_key: true
      add :hub_id, references(:hubs, column: :hub_id, on_delete: :delete_all), null: false
      add :title, :text, default: "Quiz"
      add :question, :text, null: false
      add :options, {:array, :text}, null: false
      add :correct_index, :integer, null: false
      add :active, :boolean, default: false
      timestamps()
    end

    create index(:quizzes, [:hub_id])

    create table(:quiz_answers, primary_key: false) do
      add :quiz_answer_id, :bigint, default: fragment("ret0.next_id()"), primary_key: true
      add :quiz_id, references(:quizzes, column: :quiz_id, on_delete: :delete_all), null: false
      add :account_id, references(:accounts, column: :account_id, on_delete: :delete_all)
      add :session_id, :text, null: false
      add :answer_index, :integer, null: false
      add :correct, :boolean, default: false
      timestamps()
    end

    create index(:quiz_answers, [:quiz_id])
    create index(:quiz_answers, [:account_id])
    create index(:quiz_answers, [:session_id])
  end
end
