defmodule AuroraDemo.Repo.Migrations.CreateAddressTable do
  use Ecto.Migration

  def change do
    create table(:addresses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :recipient, :string, size: 120  # Person or company name

      # Street details
      add :street_line1, :string, size: 100  # Street address line 1
      add :street_line2, :string, size: 100  # Street address line 2 (optional)

      # Locality info
      add :city, :string, size: 80           # City name
      add :state, :string, size: 50          # US states, optional elsewhere
      add :province, :string, size: 80       # Provinces (Spain/EU countries)
      add :region, :string, size: 80         # Region/autonomous community

      # Postal / country
      add :postal_code, :string, size: 20    # Postal/ZIP code
      add :country_code, :string, size: 2    # ISO 3166-1 alpha-2 (exactly 2 chars)

      timestamps()
    end

    # Optional: Add constraints for better data integrity
    execute "ALTER TABLE addresses ADD CONSTRAINT country_code_length CHECK (char_length(country_code) = 2)"

    # Indexes for better query performance
    create index(:addresses, [:country_code])
    create index(:addresses, [:postal_code])
    create index(:addresses, [:city])
    create index(:addresses, [:state])
  end
end
