defmodule Telixir.Bot.Helpers do
	alias Nadia.Model

	defmacro __using__(_opts) do
		quote do
			import Telixir.Bot.Helpers
			
			def message_text(update) do
				update
					|> message
					|> Map.get(:text)
			end
			
			def message(update), do: Map.get(update, :message)

			def sender(update) do
				update
					|> message
					|> Map.get(:from)
			end
		end
	end

	defmacro on_command(command, command_body, update, do: behaviour) do
		quote do
			def handle_msg(%Model.Update{message: %Model.Message{text: "/#{unquote(command)} " <> body}} = model_update) do
				var!(unquote(command_body)) = body
				var!(unquote(update)) = model_update
				unquote(behaviour)				
			end
		end
	end

	defmacro otherwise(update_model, do: behaviour) do
		quote do
			def handle_msg(update) do
				var!(unquote(update_model)) = update
				unquote(behaviour)
			end
		end
	end
end