defmodule CovidCheckin.Repo.Migrations.AddIndexForEvent do
  use Ecto.Migration

  def change do
    create(index(:attendees, [:event_id]))
  end
end
