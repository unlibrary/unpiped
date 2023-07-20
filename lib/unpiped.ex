defmodule UnPiped do
  @moduledoc """
  Script to pull the latest entries from Unlibrary and
  render an HTML file with a grid of videos.
  """
  require UnPiped

  @spec make_call(fun()) :: term()
  defmacro make_call(fun) do
    {{:__aliases__, _, modules}, fun, args} = Macro.decompose_call(fun)
    module = Module.concat(modules)
    server = get_server()

    quote do
      if Node.connect(unquote(server)) do
        :erpc.call(unquote(server), unquote(module), unquote(fun), unquote(args))
      else
        raise "reader daemon is not online"
      end
    end
  end

  defp get_server() do
    Application.fetch_env!(:unpiped, :server)
  end

  @spec main(list()) :: :ok
  def main(args) when is_list(args) do
    {username, browser_binary} = parse_args(args)

    posts =
      username
      |> get_account()
      |> get_posts()
      |> Enum.sort_by(& &1.date)

    html = EEx.eval_file(__DIR__ <> "/templates/index.html.eex", assigns: [posts: posts])
    output_path = "/tmp/unpiped_#{System.os_time()}.html"

    File.write!(output_path, html)
    System.cmd(browser_binary, [output_path])

    :ok
  end

  @spec parse_args(list()) :: {String.t(), String.t()}
  defp parse_args(args) do
    default_username = "yt"
    default_browser_binary = "firefox"

    case args do
      [] -> {default_username, default_browser_binary}
      [username] -> {username, default_browser_binary}
      [username, browser_binary] -> {username, browser_binary}
    end
  end

  @spec get_account(String.t()) :: map()
  defp get_account(username) do
    case make_call(UnLib.Accounts.get_by_username(username)) do
      {:ok, account} -> account
      {:error, error} -> raise "Error: #{error}"
    end
  end

  @spec get_posts(map()) :: [map()]
  defp get_posts(account) do
    make_call(UnLib.Feeds.pull(account))
    make_call(UnLib.Entries.list(account))
  end
end
