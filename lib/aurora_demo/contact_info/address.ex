defmodule AuroraDemo.ContactInfo.Address do
  use TypedEctoSchema
  import Ecto.Changeset

  alias AuroraDemo.ContactInfo.Address
  alias Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  typed_schema "addresses" do
    field :recipient, :string # Person or company name

    # Street details
    field :street_line1, :string # e.g. "Calle Mayor 15", "1600 Amphitheatre Pkwy"
    field :street_line2, :string # e.g. "3ºB", "Apt 2B", optional

    # Locality info
    field :city, :string
    field :state, :string # US states, optional elsewhere
    field :province, :string # Provinces (Spain/EU countries)
    field :region, :string # e.g. Comunidad Autónoma (Spain), Regione (Italy)

    # Postal / country
    field :postal_code, :string
    field :country_code, :string # ISO 3166-1 alpha-2, e.g. "US", "ES", "FR"

    timestamps()
  end

  @doc false
  @spec changeset(Address.t() | Changeset.t(), map()) :: Changeset.t()
  def changeset(address, attrs) do
    address
    |> cast(attrs, [
      :recipient,
      :street_line1,
      :street_line2,
      :city,
      :state,
      :province,
      :region,
      :postal_code,
      :country_code
    ])
    |> validate_required([:street_line1, :city, :postal_code, :country_code])
    |> validate_length(:country_code, is: 2)
    |> validate_country_code()
    |> validate_postal_code()
    |> validate_state_or_province()
  end

  # --- Country-specific validations ---
  defp validate_country_code(changeset) do
    code = get_field(changeset, :country_code)

    case AuroraDemo.Cldr.validate_territory(code) do
      {:ok, normalized_code} ->
        normalized_code
        |> to_string()
        |> then(&put_change(changeset, :country_code, &1))

      {:error, _} ->
        add_error(changeset, :country_code, "can't be blank and must be a valid ISO 3166-1 alpha-2 country code")
    end
  end

  @spec validate_postal_code(Changeset.t()) :: Changeset.t()
  defp validate_postal_code(changeset) do
    case get_field(changeset, :country_code) do
      "US" ->
        # ZIP: 12345 or 12345-6789
        validate_format(changeset, :postal_code, ~r/^\d{5}(-\d{4})?$/,
          message: "must be a valid US ZIP code (12345 or 12345-6789)"
        )

      "ES" ->
        # Spain: 5 digits, first two = province (01–52)
        validate_format(changeset, :postal_code, ~r/^(0[1-9]|[1-4][0-9]|5[0-2])\d{3}$/,
          message: "must be a valid Spanish postal code (e.g., 28013)"
        )

      code when code in ["FR", "DE", "IT", "NL", "BE"] ->
        # Simplified EU patterns (can be extended per country)
        validate_format(changeset, :postal_code, ~r/^[A-Za-z0-9\- ]{3,10}$/,
          message: "must be a valid postal code"
        )

      _ ->
        changeset # leave as-is for unknown countries
    end
  end

  @spec validate_state_or_province(Changeset.t()) :: Changeset.t()
  defp validate_state_or_province(changeset) do
    case get_field(changeset, :country_code) do
      "US" ->
        validate_required(changeset, [:state])

      "ES" ->
        validate_required(changeset, [:province])

      _ ->
        changeset
    end
  end
end
