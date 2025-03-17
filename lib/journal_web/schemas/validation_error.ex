defmodule JournalWeb.Schemas.ValidationError do
  require OpenApiSpex

  @moduledoc """
  Schema for validation errors returned in a 422 response.
  """

  @derive {Jason.Encoder, only: [:errors]}
  defstruct errors: %{}

  def schema do
    %OpenApiSpex.Schema{
      type: :object,
      properties: %{
        errors: %OpenApiSpex.Schema{
          type: :object,
          additionalProperties: %OpenApiSpex.Schema{
            type: :array,
            items: %OpenApiSpex.Schema{type: :string}
          },
          description: "A map of field names to validation error messages"
        }
      },
      required: [:errors]
    }
  end
end
