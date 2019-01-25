defmodule SlackToolWeb.SlackHandler do
  @moduledoc """
  execute logic slack 
  """

  @doc """
  resolve event
  """
  def handler_event(event) do
    user = event["user"]
    msg = event["text"]
    channel = event["channel"]

    case msg do
      "list_files" ->
        handler(:list_files, user, channel)

      "delete_files" ->
        handler(:delete_files, user, channel)

      _ ->
        IO.puts("#{msg} is not knowed")
    end
  end

  @doc """
  resolve command
  """
  def handler_command(params) do
    cmd = params["command"]
    user = params["user_id"]
    channel = params["channel_id"]
    IO.inspect(cmd)

    case cmd do
      "/list_files" ->
        handler(:list_files, user, channel)

      "/delete_files" ->
        handler(:delete_files, user, channel)

      _ ->
        IO.puts("#{cmd} is not knowed")
    end
  end

  def handler(:list_files, user, channel) do
    case get_files(user) do
      {:ok, files} ->
        file_reduces = Enum.map(files, fn x -> %{"id" => x["id"], "name" => x["name"]} end)
        message = Poison.encode!(file_reduces)
        send_message(user, channel, message)

      {:error} ->
        IO.inspect("Error geting file")
    end
  end

  def handler(:delete_files, user, channel) do
    case get_files(user) do
      {:ok, files} ->
        Enum.each(files, fn x -> delete_file(x, user) end)
        send_message(user, channel, "Finish!")

      {:error} ->
        IO.inspect("Error geting file")
    end
  end

  @doc """
  send message as bot
  """
  def send_message(user, channel, message) do
    token = Application.fetch_env!(:slack_tool, :oauth_access_token)

    url =
      'https://slack.com/api/chat.postMessage?token=#{token}&channel=#{channel}&text=#{message}'

    case HTTPoison.get(
           url,
           [
             {"Content-Type", "application/x-www-form-urlencoded"}
           ]
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        response = Poison.decode!(body)
        IO.inspect(response)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error}
    end
  end

  @doc """
  get all files of user
  """
  def get_files(user) do
    token = Application.fetch_env!(:slack_tool, :oauth_access_token)
    url = 'https://slack.com/api/files.list?token=#{token}&user=#{user}'

    case HTTPoison.get(
           url,
           [
             {"Content-Type", "application/x-www-form-urlencoded"}
           ]
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        response = Poison.decode!(body)

        if response["ok"] do
          files = Enum.map(response["files"], fn x -> %{"id" => x["id"], "name" => x["name"]} end)
          IO.inspect(files)
          {:ok, response["files"]}
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error}
    end
  end

  @doc """
  delete file of suer
  """
  def delete_file(file, user) do
    token = Application.fetch_env!(:slack_tool, :oauth_access_token)
    url = 'https://slack.com/api/files.delete?token=#{token}&file=#{file["id"]}'

    case HTTPoison.post(
           url,
           '',
           [
             {"Content-Type", "application/json"}
           ]
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        response = Poison.decode!(body)

        if response["ok"] do
          IO.puts("Delete file #{file["name"]} success")
        else
          IO.puts("Delete file #{file["name"]} error, reason: \n #{response["error"]}")
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end
end
