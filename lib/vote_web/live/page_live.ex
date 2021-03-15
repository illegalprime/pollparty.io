defmodule VoteWeb.PageLive do
  use VoteWeb, :live_view
  alias VoteWeb.Authentication
  alias Vote.Ballots
  alias Vote.Ballots.ResponseSet

  @impl true
  def mount(_params, session, socket) do
    {:ok, user} = Authentication.load_user(session)
    my_ballots = Ballots.authored_by_user(user)
    voted_ballots = ResponseSet.find_ballots(user.id)

    socket
    |> assign(account: user)
    |> assign(page_title: "Home")
    |> assign(my_ballots: my_ballots)
    |> assign(voted_ballots: voted_ballots)
    |> ok()
  end
end
