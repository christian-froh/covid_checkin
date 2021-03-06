defmodule CovidCheckin.Attendees do
  @moduledoc """
  The Attendees context.
  """

  import Ecto.Query, warn: false
  alias CovidCheckin.Repo

  alias CovidCheckin.Events.Attendee

  def list(event_id, %{page: page, per_page: per_page}) do
    query =
      from a in Attendee,
        where: a.event_id == ^event_id,
        offset: ^((page - 1) * per_page),
        limit: ^per_page,
        order_by: [{:desc, :inserted_at}]

    Repo.all(query)
  end

  def create_attendees(event) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    attendees_params =
      1..event.max_attendees
      |> Enum.map(fn _ -> %{event_id: event.id, inserted_at: now, updated_at: now} end)

    Repo.insert_all(Attendee, attendees_params)
    {:ok, true}
  end

  def get_attendee!(id) do
    attendee = Repo.get!(Attendee, id)
    Repo.preload(attendee, :event)
  end

  def register_attendee(%Attendee{} = attendee, attrs) do
    attendee
    |> Attendee.register_changeset(attrs)
    |> Repo.update()
    |> broadcast(:attendee_registered)
  end

  def update_attendee(%Attendee{} = attendee, attrs \\ %{}) do
    attendee
    |> Attendee.update_changeset(attrs)
    |> Repo.update()
    |> broadcast(:attendee_updated)
  end

  def leave_event(%Attendee{} = attendee, attrs \\ %{}) do
    attendee
    |> Attendee.leave_changeset()
    |> Repo.update()
    |> broadcast(:attendee_left_event)
  end

  defp broadcast({:ok, attendee}, event) do
    Phoenix.PubSub.broadcast(
      CovidCheckin.PubSub,
      "attendees",
      {event, attendee}
    )

    {:ok, attendee}
  end

  defp broadcast({:error, _reason} = error, _event), do: error
end
