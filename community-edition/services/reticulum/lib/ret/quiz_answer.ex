defmodule Ret.QuizAnswer do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Ret.{Repo, QuizAnswer}

  @schema_prefix "ret0"
  @primary_key {:quiz_answer_id, :id, autogenerate: true}

  schema "quiz_answers" do
    belongs_to :quiz, Ret.Quiz, references: :quiz_id
    belongs_to :account, Ret.Account, references: :account_id
    field :session_id, :string
    field :answer_index, :integer
    field :correct, :boolean, default: false

    timestamps()
  end

  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:quiz_id, :account_id, :session_id, :answer_index, :correct])
    |> validate_required([:quiz_id, :session_id, :answer_index])
    |> foreign_key_constraint(:quiz_id)
    |> foreign_key_constraint(:account_id)
  end

  def for_quiz_and_session(quiz_id, session_id) do
    Repo.all(
      from a in QuizAnswer,
        where: a.quiz_id == ^quiz_id and a.session_id == ^session_id
    )
  end
end
