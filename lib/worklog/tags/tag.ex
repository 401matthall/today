defmodule Today.Tag do
  use Ecto.Schema

  schema "tags" do
    field :text, :string
    field :user_id, :integer
    timestamps()

    many_to_many(:worklogs, Worklog, join_through: "worklogs_tags")
  end

  def changeset(worklog, params \\ %{}) do
    worklog
    |> Ecto.Changeset.cast(params, [:text, :user_id])
    # @TODO limit length of Tag to 30 characters?
    |> Ecto.Changeset.validate_required([:text, :user_id])
  end
end
