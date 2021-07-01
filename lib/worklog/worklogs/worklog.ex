defmodule Today.Worklog do
  use Ecto.Schema
  alias Today.Tag
  alias Today.WorklogTag

  schema "worklogs" do
    field :title, :string
    field :body, :string
    field :user_id, :integer
    timestamps()

    many_to_many(:tags, Tag, join_through: WorklogTag)
  end

  def changeset(worklog, params \\ %{}) do
    worklog
    |> Ecto.Changeset.cast(params, [:title, :body, :user_id])
    |> Ecto.Changeset.validate_required([:body, :user_id])
  end
end
