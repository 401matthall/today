defmodule Today.Repo.Migrations.ChangeWorklogsBodyToText do
  use Ecto.Migration

  def change do
      alter table(:worklogs) do
      modify :body,  :text
    end
  end

end
