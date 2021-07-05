defmodule Today.Tag do
  use Ecto.Schema
  alias Ecto.Changeset
  alias Today.{Worklog, WorklogTag}

  schema "tags" do
    field :text, :string
    field :user_id, :integer
    timestamps()

    many_to_many(:worklogs, Worklog, join_through: WorklogTag)
  end

  def changeset(worklog, params \\ %{}) do
    worklog
    |> Changeset.cast(params, [:text, :user_id])
    # @TODO limit length of Tag to 30 characters?
    |> Changeset.validate_required([:text, :user_id])
    |> Changeset.update_change(:text, &String.downcase/1)
    |> Changeset.unique_constraint([:text, :user_id], name: :text_user_id_index)
  end
end
