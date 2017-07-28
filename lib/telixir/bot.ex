defmodule Telixir.Bot do
	use GenServer    
	
	alias Telixir.Bot

	def start_link do
		GenServer.start_link(__MODULE__,:ok, name: __MODULE__)
	end

	def init(:ok) do
		update()
		{:ok, 0}        
	end

	defp update do
		GenServer.cast(__MODULE__, :update)        
	end

	def handle_info(:timeout, last_update_id) do
		update()        
		{:noreply, last_update_id}
	end

	def handle_cast(:update, last_update_id) do
		latest_update_id = Nadia.get_updates([offset: last_update_id]) |> process_updates(last_update_id)
		{:noreply, latest_update_id, 100}
	end

	defp process_updates({:ok, []}, last_id), do: last_id

	defp process_updates({:ok, updates}, _) do
		Enum.each(updates, &process_update/1)
		%{update_id: last_id} = List.last(updates)
		last_id + 1
	end

	defp process_updates(_, last_id), do: last_id

	defp process_update(update), do: Task.start(fn -> Bot.Responses.handle_msg(update) end) 
end