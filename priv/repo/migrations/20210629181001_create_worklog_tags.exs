defmodule Today.Repo.Migrations.CreateWorklogsTags do
  use Ecto.Migration

  def change do
    create table(:worklogs_tags) do
      add :worklog, :integer, null: false
      add :tag, :integer, null: false
      timestamps()
    end
  end
end
