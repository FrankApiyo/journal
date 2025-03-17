defmodule JournalWeb.AuthController do
  use JournalWeb, :controller

  use OpenApiSpex.ControllerSpecs
  alias Journal.Accounts
  alias Journal.Guardian

  alias JournalWeb.Schemas.{UserCredentials, UserParams, User}

  tags(["users"])

  operation(:signup,
    summary: "Sign up",
    description: "Creates a new user account",
    security: [%{"apiKeyAuth" => []}],
    request_body: {"User params", "application/json", UserParams},
    responses: %{
      201 => {"User response", "application/json", User},
      422 => {"Validation errors", "application/json", JournalWeb.Schemas.ValidationError}
    }
  )

  def signup(conn, %{"email" => email, "password" => password}) do
    case Accounts.register_user(%{email: email, password: password}) do
      {:ok, user} ->
        json(conn, %{message: "User Created", user: user_response(user)})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: errors_from_changeset(changeset)})
    end
  end

  defp user_response(user) do
    %{
      id: user.id,
      email: user.email,
      inserted_at: user.inserted_at,
      confirmed_at: user.confirmed_at
    }
  end

  operation(:login,
    summary: "login",
    description: "exchange email and password for auth token",
    security: [%{"apiKeyAuth" => []}],
    request_body: {"User params", "application/json", UserParams},
    responses: %{
      200 => {"User response", "application/json", UserCredentials},
      401 => {"Unauthorized", "application/json", JournalWeb.Schemas.UnauthorizedError}
    }
  )

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        json(conn, %{token: token})

      _ ->
        conn |> put_status(:unauthorized) |> json(%{error: "Invalid credentials"})
    end
  end

  defp errors_from_changeset(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
