defmodule Telixir.Bot.Responses do
	use Telixir.Bot.Helpers

	on_command("hola", _body, update) do
		IO.inspect sender(update)
	end

	otherwise(_update) do
		IO.puts("Otra cosa")
	end
end