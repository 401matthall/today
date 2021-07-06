defmodule Today.WorklogTag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "worklogs_tags" do
    field :worklog_id, :integer
    field :tag_id, :integer

    timestamps()
  end

    @doc false
    def changeset(worklog_tag, attrs) do
      worklog_tag
      |> cast(attrs, [])
      |> validate_required([])
      |> unique_constraint([:worklog_id, :tag_id], name: :worklogs_tags_worklog_id_tag_id_index)
    end
end
