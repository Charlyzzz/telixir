defmodule Telixir.Bot.Helpers do
    alias Nadia.Model
    alias Telixir.Bot.Helpers
    
    defmacro __using__(_opts) do
        quote do
            import Telixir.Bot.Helpers

            def message(update), do: update |> Map.get(:message) |> Map.get(:text)
        end
    end    

    defmacro on_command(command, do: behaviour) do
        quote do
            def handle_msg(%Model.Update{message: %Model.Message{text: "/" <> command}} = update) do
                unquote(behaviour)
            end
        end
    end

    defmacro on(words, do: behaviour) when is_list(words) do
        Enum.each(words, fn word -> 
                    on(unquote(word), do: unquote(behaviour))
                end
        end)        
    end
    
    defmacro on(command, do: behaviour) do
        quote do
            def handle_msg(update) do
                if message(update) == word, do: unquote(behaviour)
            end
        end
    end    

    defmacro when_matches(regex, do: behaviour) do
        quote do
            def handle_msg(update) do
                if Regex.match?(unquote(regex), message(update)) do
                    unquote(behaviour)
                end
            end
        end
    end
end