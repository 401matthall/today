defmodule Today.Repo.Migrations.CreateWorklogsTags do
  use Ecto.Migration

  def change do
    create table(:worklogs_tags) do
      add :worklog_id, references(:worklogs, on_delete: :nothing)
      add :tag_id, references(:tags, on_delete: :nothing)
      timestamps()
    end

    create index(:worklogs_tags, [:worklog_id, :tag_id], unique: true)
    create index(:worklogs_tags, [:worklog_id])
    create index(:worklogs_tags, [:tag_id])
  end
end
