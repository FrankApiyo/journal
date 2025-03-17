defmodule JournalWeb.AuthControllerTest do
  use JournalWeb.ConnCase, async: true

  @valid_attrs %{"email" => "test@example.com", "password" => "securepassword"}
  @invalid_attrs %{"email" => "test@example.com", "password" => "secret"}
  @login_invalid_attrs %{"email" => "test@example.com", "password" => "wrongpassword"}

  describe "POST /api/signup" do
    test "returns error when password is too short", %{conn: conn} do
      conn = post(conn, ~p"/api/signup", @invalid_attrs)

      assert json_response(conn, 422) == %{
               "errors" => %{
                 "password" => ["should be at least 12 character(s)"]
               }
             }
    end

    test "creates a user with valid attributes", %{conn: conn} do
      conn = post(conn, ~p"/api/signup", @valid_attrs)
      response = json_response(conn, 200)

      assert match?(
               %{
                 "message" => "User Created",
                 "user" => %{
                   "email" => "test@example.com",
                   "confirmed_at" => nil
                 }
               },
               response
             )

      assert is_integer(response["user"]["id"])
      assert response["user"]["inserted_at"] =~ ~r/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/
    end
  end

  describe "POST /api/login" do
    setup %{conn: conn} do
      {:ok, user} = Journal.Accounts.register_user(@valid_attrs)
      {:ok, conn: conn, user: user}
    end

    test "logs in with valid credentials and returns a valid token", %{conn: conn, user: user} do
      conn = post(conn, ~p"/api/login", @valid_attrs)
      response = json_response(conn, 200)

      assert Map.has_key?(response, "token")
      token = response["token"]
      assert is_binary(token)

      # Is this token valid?
      assert {:ok, claims} = Journal.Guardian.decode_and_verify(token)

      # Verify the token contains a user ID (or expected claim)
      assert Map.has_key?(claims, "sub")
      assert is_binary(claims["sub"])
      assert String.to_integer(claims["sub"]) == user.id
    end

    test "returns error with invalid credentials", %{conn: conn} do
      conn = post(conn, ~p"/api/login", @login_invalid_attrs)

      assert json_response(conn, 401) == %{"error" => "Invalid credentials"}
    end
  end
end
