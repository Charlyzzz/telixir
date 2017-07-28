defmodule Telixir do

	def start(_type, _args) do
		{:ok, token} = Application.fetch_env(:telixir, :bot_token)
		Application.put_env(:nadia, :token, token)
		Telixir.Supervisor.start_link 
	end
end
