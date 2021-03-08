defmodule Vote.Ballots.Ballot do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ballots" do
    field :title, :string
    field :desc, :string
    field :public, :boolean, default: true
    has_many :ballot_items, Vote.Ballots.BallotItem
    belongs_to :account, Vote.Accounts.Account

    timestamps()
  end

  @doc false
  def changeset(ballot, attrs) do
    ballot
    |> cast(attrs, [:title, :desc, :public])
    |> cast_assoc(:ballot_items, required: true)
    |> validate_required([:title])
    |> unique_constraint(:title)
  end
end
