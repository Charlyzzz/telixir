defmodule Telixir.Bot do
    alias Telixir.{Parallel, Bot}

    require Telixir.Bot.Responses

    use GenServer    

    def start_link(name) do
        GenServer.start_link(__MODULE__,:ok, name: name)
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
        Parallel.each(updates, &Bot.Responses.handle_msg/1)
        %{update_id: last_id} = List.last(updates)
        last_id + 1
    end

    defp process_updates(_, last_id), do: last_id
end