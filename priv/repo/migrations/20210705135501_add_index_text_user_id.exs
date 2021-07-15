defmodule Today.Repo.Migrations.CreateTags do
  use Ecto.Migration
  alias Today.Tags

  def change do
    create index(Tags, [:text, :user_id], name: :tags_text_user_id_index, unique: true)
  end
end
