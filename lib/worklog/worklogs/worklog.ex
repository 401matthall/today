defmodule Today.Worklog do
  use Ecto.Schema

  schema "worklogs" do
    field :title, :string
    field :body, :string
    field :user_id, :integer
    timestamps()
  end

  def changeset(worklog, params \\ %{}) do
    worklog
    |> Ecto.Changeset.cast(params, [:title, :body, :user_id])
    |> Ecto.Changeset.validate_required([:body, :user_id])
  end
end
