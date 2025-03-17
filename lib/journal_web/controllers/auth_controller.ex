defmodule JournalWeb.AuthController do
  use JournalWeb, :controller
  alias Journal.Accounts
  alias Journal.Guardian

  def signup(conn, %{"email" => email, "password" => password}) do
    case Accounts.register_user(%{email: email, password: password}) do
      {:ok, user} -> json(conn, %{message: "User created", user: user})
      {:error, changeset} -> json(conn, %{error: changeset})
    end
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
end
