defmodule CovidCheckin.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :max_attendees, :integer

      timestamps()
    end

    create table(:attendees) do
      add :first_name, :string
      add :last_name, :string
      add :address, :text
      add :telefon, :string
      add :healthy, :boolean
      add :currently_at_event, :boolean

      add :event_id, references(:events)

      timestamps()
    end
  end
end
