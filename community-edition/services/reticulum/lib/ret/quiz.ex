defmodule Ret.Quiz do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Ret.{Repo, Quiz, QuizAnswer}

  @schema_prefix "ret0"
  @primary_key {:quiz_id, :id, autogenerate: true}

  schema "quizzes" do
    belongs_to :hub, Ret.Hub, references: :hub_id
    field :title, :string
    field :question, :string
    field :options, {:array, :string}
    field :correct_index, :integer
    field :active, :boolean, default: false

    has_many :quiz_answers, Ret.QuizAnswer, foreign_key: :quiz_id

    timestamps()
  end

  def changeset(quiz, attrs) do
    quiz
    |> cast(attrs, [:hub_id, :title, :question, :options, :correct_index, :active])
    |> validate_required([:hub_id, :question, :options, :correct_index])
    |> validate_length(:options, min: 2)
    |> validate_number(:correct_index, greater_than_or_equal_to: 0)
  end

  def active_for_hub(hub_id) do
    Repo.all(
      from q in Quiz,
        where: q.hub_id == ^hub_id and q.active == true
    )
  end
end
