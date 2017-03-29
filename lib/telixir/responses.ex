defmodule Telixir.Bot.Responses do
    use Telixir.Bot.Helpers
   
    on_command "hola" do
        IO.puts 1
    end

    on "hola" do
        IO.puts 0
    end

    when_matches ~r/foo/ do
        IO.puts 2
    end         
end