defmodule Ret.UserProgress do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Ret.{Repo, UserProgress}

  @schema_prefix "ret0"
  @primary_key {:user_progress_id, :id, autogenerate: true}

  schema "user_progress" do
    belongs_to :account, Ret.Account, references: :account_id
    belongs_to :hub, Ret.Hub, references: :hub_id
    field :session_id, :string
    field :element_slug, :string
    field :element_type, :string
    field :status, :string, default: "visited"
    field :score, :integer
    field :max_score, :integer
    field :time_spent_ms, :integer, default: 0
    field :visited_count, :integer, default: 1
    field :metadata, :map, default: %{}

    timestamps()
  end

  @valid_statuses ~w(visited started completed)

  def changeset(progress, attrs) do
    progress
    |> cast(attrs, [:account_id, :hub_id, :session_id, :element_slug, :element_type, :status, :score, :max_score, :time_spent_ms, :visited_count, :metadata])
    |> validate_required([:hub_id, :session_id, :element_slug, :element_type])
    |> validate_inclusion(:status, @valid_statuses)
    |> validate_inclusion(:element_type, ~w(element experiment quiz))
    |> foreign_key_constraint(:account_id)
    |> foreign_key_constraint(:hub_id)
    |> unique_constraint(:account_id, name: :user_progress_account_id_hub_id_element_slug_index)
    |> validate_score_not_exceeding_max()
  end

  defp validate_score_not_exceeding_max(changeset) do
    max_score = get_field(changeset, :max_score)
    if max_score do
      validate_number(changeset, :score, less_than_or_equal_to: max_score)
    else
      changeset
    end
  end

  def for_hub(hub_id) do
    Repo.all(
      from p in UserProgress,
        where: p.hub_id == ^hub_id,
        order_by: [asc: p.element_slug]
    )
  end

  def for_account_and_hub(account_id, hub_id) do
    Repo.all(
      from p in UserProgress,
        where: p.account_id == ^account_id and p.hub_id == ^hub_id,
        order_by: [asc: p.element_slug]
    )
  end

  def for_session_and_hub(session_id, hub_id) do
    Repo.all(
      from p in UserProgress,
        where: p.session_id == ^session_id and p.hub_id == ^hub_id,
        order_by: [asc: p.element_slug]
    )
  end
end
