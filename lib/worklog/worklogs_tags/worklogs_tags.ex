defmodule Today.WorklogTag do
  use Ecto.Schema
  import Ecto.Changeset
  alias Today.{Worklog, Tag}

  schema "worklogs_tags" do
    belongs_to(:worklogs, Worklog)
    belongs_to(:tags, Tag)
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
