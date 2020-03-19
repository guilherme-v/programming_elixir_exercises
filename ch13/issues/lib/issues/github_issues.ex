defmodule Issues.GithubIssues do
  require Logger

  @user_agent [{"User-agent", "Elixir dave@pragprog.com"}]

  def fetch(user, project) do
    Logger.info("Fetching user #{user}'s project #{project}")

    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Logger.info("Successful response")
    Logger.debug(fn -> inspect(body) end)
    {:ok, :jsx.decode(body)}
  end

  def handle_response({:error, %HTTPoison.Response{status_code: status, body: body}}) do
    Logger.error("Error #{status} returned")
    {:ok, :jsx.decode(body)}
  end

  def handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    Logger.error("Error #{reason} returned")
    {:error, reason}
  end
end
