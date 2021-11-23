defmodule Today.Worklog do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Today.{Tag, Worklog, WorklogTag, Repo}

  require Logger

  schema "worklogs" do
    field :title, :string
    field :body, :string
    field :user_id, :integer
    field :tag_string, :string, virtual: true
    timestamps()

    many_to_many(:tags, Tag, join_through: WorklogTag, on_replace: :delete)
  end

  def changeset(worklog, params \\ %{}) do
    worklog
    |> cast(params, [:title, :body, :user_id, :tag_string])
    |> validate_required([:body, :user_id])
    |> put_assoc(:tags, parse_tags(params))
    |> change(%{tag_string: nil})
  end

  defp parse_tags(params)  do
    tags = (params.tag_string || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    get_or_insert_tags(tags, params.user_id)
  end

  defp get_or_insert_tags(tags, user_id) do
    Enum.map(tags, &(get_or_insert_tag(&1, user_id)))
  end

  def get_or_insert_tag(text, user_id) do
    %Tag{}
    |> change(%{text: text, user_id: user_id})
    |> unique_constraint([:text, :user_id])
    |> update_change(:text, &String.downcase/1)
    |> Repo.insert
    |> case do
      {:ok, tag} -> tag
      {:error, _} -> Tag |> where(text: ^text) |> where(user_id: ^user_id) |> Repo.one
    end
  end

  def fetch_by_id(id) when is_integer(id) do
    Repo.get(Worklog, id)
  end

  def fetch_by_id_with_tags(id) do
    Repo.get(Worklog, id)
    |> Repo.preload(:tags)

  end

  def by_user_id(user_id) when is_integer(user_id) do
    from w in Worklog, where: w.user_id == ^user_id, order_by: [desc: w.id]
  end

  def by_tag_id(query, tag_id) do
    from w in query, distinct: true,
    join: wt in WorklogTag, on: wt.worklog_id == w.id,
    join: t in Tag, on: wt.tag_id == t.id,
    preload: [:tags],
    where: t.id == ^tag_id,
    order_by: [desc: w.id]
  end

  def by_tag_text(query, tag_text) do
    from w in query, distinct: true,
    join: wt in WorklogTag, on: wt.worklog_id == w.id,
    join: t in Tag, on: wt.tag_id == t.id,
    preload: [:tags],
    where: ilike(t.text, ^"%#{tag_text}%"),
    order_by: [desc: w.id]
  end

  def fetch_by_user_id(user_id) do
    Repo.all(by_user_id(user_id))
  end

  def apply_pagination(query, page_number, per_page) do
    page_number = case page_number do
      n when n < 0 -> 0
      n when n == 0 -> 0
      n when n > 0 -> n - 1
    end
    skip_count = page_number * per_page
    Ecto.Query.offset(query, ^skip_count)
  end

  def query_by_tag_id(tag_id) do
    from w in Worklog, distinct: true,
    join: wt in WorklogTag, on: wt.worklog_id == w.id,
    join: t in Tag, on: wt.tag_id == t.id,
    preload: [:tags],
    where: t.id == ^tag_id,
    order_by: [desc: w.id]
  end

  def query_by_user_id_and_tag_id(user_id, tag_id) do
    query_by_tag_id(tag_id)
    |> where([w], w.user_id == ^user_id)
  end

  def fetch_by_user_id_and_tag_id(user_id, tag_id) do
    query_by_user_id_and_tag_id(user_id, tag_id)
    |> Repo.all
  end

  def fetch_with_assoc_by_id(id) when is_integer(id) do
    fetch_by_id(id)
    |> Repo.preload(:tags)
  end

  def fetch_with_assoc_by_user_id(user_id) when is_integer(user_id) do
    fetch_by_user_id(user_id)
    |> Repo.preload(:tags)
  end

  def fetch_by_user_id_and_tag_text(user_id, tag_text) when is_integer(user_id) do
    query_by_user_id_and_tag_text(user_id, tag_text)
    |> Repo.all
  end

  def query_by_user_id_and_tag_text(user_id, tag_text) when is_integer(user_id) do
    from w in Worklog, distinct: true,
    join: wt in WorklogTag, on: wt.worklog_id == w.id,
    join: t in Tag, on: wt.tag_id == t.id,
    preload: [:tags],
    where: w.user_id == ^user_id and ilike(t.text, ^"%#{tag_text}%"),
    order_by: [desc: w.id]
  end

  def create_update_changeset(worklog = %Worklog{}) do
    Ecto.Changeset.change(worklog, %{title: worklog.title, body: worklog.body, tags: []})
  end
end
