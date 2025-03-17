defmodule JournalWeb.Plugs.RequireSignupToken do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(%Plug.Conn{req_headers: headers} = conn, _opts) do
    api_key = headers |> Enum.find_value(fn {key, val} -> if key == "x-api-key", do: val end)
    expected_key = Application.get_env(:journal, :api_auth)[:signup_token]

    if api_key == expected_key do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "Invalid API key"})
      |> halt()
    end
  end
end
