defmodule Chatter.User do
  use Ecto.Schema
  import Ecto.{Changeset, Query}

  alias Chatter.Repo

  schema "users" do
    field :email, :string
    field :encrypt_pass, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
  end

  def reg_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:password], [])
    |> validate_length(:password, min: 5)
    |> hash_pw()
  end

  def hash_pw(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: p}} ->
        put_change(changeset, :encrypt_pass, Bcrypt.hash_pwd_salt(p))

      _ ->
        changeset
    end
  end

  def authenticate_user(email, plain_text_password) do
    query = from u in __MODULE__, where: u.email == ^email

    case Repo.one(query) do
      nil ->
        Bcrypt.no_user_verify()
        {:error, :invalid_credentials}

      user ->
        if Bcrypt.verify_pass(plain_text_password, user.encrypt_pass) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end
end
