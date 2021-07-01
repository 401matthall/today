defmodule Today.Tag do
  use Ecto.Schema
  alias Today.Worklog
  alias Today.WorklogTag

  schema "tags" do
    field :text, :string
    field :user_id, :integer
    timestamps()

    many_to_many(:worklogs, Worklog, join_through: WorklogTag)
  end

  def changeset(worklog, params \\ %{}) do
    worklog
    |> Ecto.Changeset.cast(params, [:text, :user_id])
    # @TODO limit length of Tag to 30 characters?
    |> Ecto.Changeset.validate_required([:text, :user_id])
  end
end
