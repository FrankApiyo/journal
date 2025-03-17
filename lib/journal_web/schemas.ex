defmodule JournalWeb.Schemas do
  alias OpenApiSpex.Schema

  defmodule User do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      # The title is optional. It defaults to the last section of the module name.
      # So the derived title for Journal.User is "User".
      title: "User",
      description: "A user of the app",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "User ID"},
        email: %Schema{type: :string, description: "Email address", format: :email},
        inserted_at: %Schema{
          type: :string,
          description: "Creation timestamp",
          format: :"date-time"
        },
        updated_at: %Schema{type: :string, description: "Update timestamp", format: :"date-time"},
        confirmed_at: %Schema{
          type: :string,
          description: "Confirmation timestamp",
          format: :"date-time"
        }
      },
      required: [:email, :id, :updated_at, :inserted_at],
      example: %{
        "id" => 123,
        "email" => "joe@gmail.com",
        "inserted_at" => "2017-09-12T12:34:55Z",
        "updated_at" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule UserParams do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "User Params",
      description: "paramaters for creating users",
      type: :object,
      properties: %{
        email: %Schema{type: :string, description: "Email address", format: :email},
        password: %Schema{
          type: :string,
          description: "User password",
          format: :password,
          minLength: 8
        }
      },
      required: [:email, :password],
      example: %{
        "password" => "securepassword",
        "email" => "joe@gmail.com"
      }
    })
  end

  defmodule UserCredentials do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "User Credentails",
      description: "redentails returned from login API",
      type: :object,
      properties: %{
        token: %Schema{
          type: :string,
          description: "JTW token for user"
        }
      },
      required: [:email, :password],
      example: %{
        "token" =>
          "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJqb3VybmFsIiwiZXhwIjoxNzQ0NjM2NjYwLCJpYXQiOjE3NDIyMTc0NjAsImlzcyI6ImpvdXJuYWwiLCJqdGkiOiJhNzMwNmFlOS0zODM5LTQ1NzItODNiMS1lMjZiZDA1MDU5ZjMiLCJuYmYiOjE3NDIyMTc0NTksInN1YiI6IjMyOTIiLCJ0eXAiOiJhY2Nlc3MifQ.7lUjAvLjIDkBG6MuE79SOBrKk2JY17wcZe2AlLNuLddzXOuAReMMbi-xWifbjTJi4PNBkBtiXxS8EjaXrTxtIQ"
      }
    })
  end
end
