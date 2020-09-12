defmodule CovidCheckin.Attendees do
  @moduledoc """
  The Attendees context.
  """

  import Ecto.Query, warn: false
  alias CovidCheckin.Repo

  alias CovidCheckin.Events.Attendee

  def create_attendees(event) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    attendees_params =
      1..event.max_attendees
      |> Enum.map(fn _ -> %{event_id: event.id, inserted_at: now, updated_at: now} end)

    Repo.insert_all(Attendee, attendees_params)
    {:ok, true}
  end

  def get_attendee!(id) do
    Repo.get!(Attendee, id)
  end

  def register_attendee(%Attendee{} = attendee, attrs) do
    attendee
    |> Attendee.register_changeset(attrs)
    |> Repo.update()
  end

  def change_attendee(%Attendee{} = attendee, attrs \\ %{}) do
    Attendee.register_changeset(attendee, attrs)
  end
end
