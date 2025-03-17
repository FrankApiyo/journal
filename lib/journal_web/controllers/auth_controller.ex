defmodule JournalWeb.AuthController do
  use JournalWeb, :controller
  alias Journal.Accounts
  alias Journal.Guardian

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
