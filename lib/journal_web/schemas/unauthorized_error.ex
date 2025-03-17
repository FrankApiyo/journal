defmodule JournalWeb.Schemas.UnauthorizedError do
  require OpenApiSpex

  @moduledoc """
  Schema for an unauthorized error response.
  """

  @derive {Jason.Encoder, only: [:error]}
  defstruct error: nil

  @doc false
  def schema do
    %OpenApiSpex.Schema{
      type: :object,
      properties: %{
        error: %OpenApiSpex.Schema{
          type: :string,
          example: "Invalid credentials",
          description: "Error message"
        }
      },
      required: [:error]
    }
  end
end
