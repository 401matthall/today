defmodule Today.Repo.Migrations.AddUsersTimezones do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :timezone, :string
    end
  end
end
