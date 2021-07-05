defmodule Today.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create index(:tags, [:text, :user_id], name: :text_user_id_index, unique: true)
  end
end