defmodule Today.WorklogTag do
  use Ecto.Schema
  alias Today.{Worklog, Tag}

  schema "worklogs_tags" do
    belongs_to(:worklogs, Worklog)
    belongs_to(:tags, Tag)
  end
end
