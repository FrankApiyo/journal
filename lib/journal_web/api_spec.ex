defmodule JournalWeb.ApiSpec do
  alias OpenApiSpex.{Components, SecurityScheme, Info, OpenApi, Paths, Server}
  alias JournalWeb.{Endpoint, Router}
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        # Populate the Server info from a phoenix endpoint
        Server.from_endpoint(Endpoint)
      ],
      info: %Info{
        title: to_string(Application.spec(:journal, :description)),
        version: to_string(Application.spec(:journal, :vsn))
      },
      # Populate the paths from a phoenix router
      paths: Paths.from_router(Router),
      components: %Components{
        securitySchemes: %{
          "apiKeyAuth" => %SecurityScheme{
            type: "apiKey",
            in: "header",
            name: "x-api-key",
            description: """
            API key authentication required to create a user.
            - Include `x-api-key` in the request headers.
            - You must obtain this API key from the system administrator.
            """
          }
        }
      }
    }
    # Discover request/response schemas from path specs
    |> OpenApiSpex.resolve_schema_modules()
  end
end
