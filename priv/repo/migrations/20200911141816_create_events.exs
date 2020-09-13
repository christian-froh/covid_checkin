defmodule CovidCheckin.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add :name, :string
      add :max_attendees, :integer

      timestamps()
    end

    create table(:attendees, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add :first_name, :string
      add :last_name, :string
      add :address, :text
      add :telefon, :string
      add :healthy, :boolean
      add :currently_at_event, :boolean
      add :registered_at, :utc_datetime
      add :left_event_at, :utc_datetime

      add :event_id, references(:events, type: :uuid)

      timestamps()
    end
  end
end
