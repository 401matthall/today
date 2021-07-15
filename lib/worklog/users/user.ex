defmodule Today.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowEmailConfirmation]
  import Ecto.Changeset
  alias Today.{Users.User, Repo}

  schema "users" do
    field :uuid, :string
    field :timezone, :string
    pow_user_fields()
    timestamps()
    has_many :worklogs, Today.Worklog
    has_many :tags, Today.Tag
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
    |> cast(attrs, [:uuid])
    |> generate_uuid
    |> update_change(:email, &String.downcase/1)
  end

  def changeset_email_confirmation(changeset, attrs) do
    changeset
    |> cast(attrs, [:email_confirmed_at])
  end

  defp generate_uuid(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} -> put_change(changeset, :uuid, UUID.uuid4)
      _ -> changeset
    end
  end

  def create_user(email, password, timezone) do
    %User{}
    |> changeset(%{email: email, password: password, password_confirmation: password, timezone: timezone})
    |> changeset_email_confirmation(%{email_confirmed_at: Timex.now()})
    |> Repo.insert()
  end

end
