defmodule Today.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowEmailConfirmation]
  import Ecto.Changeset
  alias Ecto.Changeset

  schema "users" do
    field :uuid, :string
    pow_user_fields()
    timestamps()
    has_many :worklogs, Today.Worklog
    has_many :tags, Today.Tag
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
    |> Changeset.cast(attrs, [:uuid])
    |> generate_uuid
    |> Changeset.update_change(:email, &String.downcase/1)
  end

  defp generate_uuid(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} -> put_change(changeset, :uuid, UUID.uuid4)
      _ -> changeset
    end
  end

end
