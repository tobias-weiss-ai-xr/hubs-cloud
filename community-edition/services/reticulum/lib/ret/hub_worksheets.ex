defmodule Ret.HubWorksheets do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Ret.{Repo, HubWorksheets}

  @schema_prefix "ret0"
  @primary_key {:worksheet_id, :id, autogenerate: true}

  schema "hub_worksheets" do
    belongs_to :hub, Ret.Hub, references: :hub_id
    field :title, :string
    field :steps, {:array, :map}, default: []
    field :active, :boolean, default: true
    timestamps()
  end

  def changeset(worksheet, attrs) do
    worksheet
    |> cast(attrs, [:hub_id, :title, :steps, :active])
    |> validate_required([:hub_id, :title])
  end

  def for_hub(hub_id) do
    Repo.all(
      from w in HubWorksheets,
        where: w.hub_id == ^hub_id,
        order_by: [desc: w.inserted_at]
    )
  end
end
