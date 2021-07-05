defmodule Today.Worklog do
  use Ecto.Schema

  import Ecto.Query

  alias Today.{Tag, Worklog, WorklogTag, Repo}

  schema "worklogs" do
    field :title, :string
    field :body, :string
    field :user_id, :integer
    timestamps()

    many_to_many(:tags, Tag, join_through: WorklogTag, on_replace: :delete)
  end

  def changeset(worklog, params \\ %{}) do
    worklog
    |> Ecto.Changeset.cast(params, [:title, :body, :user_id])
    |> Ecto.Changeset.validate_required([:body, :user_id])
  end

  def fetch_by_id(id) when is_integer(id) do
    Repo.get(Worklog, id)
  end

  def fetch_by_user_id(user_id) when is_integer(user_id) do
    Repo.all(from w in Worklog, where: w.user_id == ^user_id)
  end

  def fetch_by_tag_id(tag_id) when is_integer(tag_id) do
  end

  def fetch_with_assoc_by_id(id) when is_integer(id) do
    fetch_by_id(id)
    |> Repo.preload(:tags)
  end

  def fetch_with_assoc_by_user_id(user_id) when is_integer(user_id) do
    fetch_by_user_id(user_id)
    |> Repo.preload(:tags)
  end
end
