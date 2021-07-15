defmodule Today.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create index(:tags_text_user_id, [:text, :user_id], name: :tags_text_user_id_index, unique: true)
  end
end
