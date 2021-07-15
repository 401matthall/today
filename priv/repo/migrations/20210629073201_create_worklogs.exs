defmodule Today.Repo.Migrations.CreateWorklogs do
  use Ecto.Migration

  def change do
    create table(:worklogs) do
      add :body, :text, null: false
      add :title, :string, null: true
      add :user_id, :integer

      timestamps()
    end
  end
end
