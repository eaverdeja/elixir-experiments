defmodule ChatterWeb.Auth.Guardian do
  use Guardian, otp_app: :chatter

  alias Chatter.{Repo, User}

  def subject_for_token(%User{id: id} = _user, _claims) do
    {:ok, "User:#{id}"}
  end

  def subject_for_token(_, _), do: {:error, :unhandled_resource_type}

  def resource_from_claims(%{"sub" => "User:" <> id}) do
    case Repo.get_by(User, %{id: id}) do
      nil -> {:error, :user_not_found}
      user -> {:ok, user}
    end
  end
end
