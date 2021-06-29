defmodule Today.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :text, :string, null: false
      add :user_id, :integer
      timestamps()
    end
  end
end
