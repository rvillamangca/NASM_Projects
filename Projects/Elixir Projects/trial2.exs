defmodule T001 do
   Code.require_file "./trial.exs"
   t_st = :os.system_time :millisecond
   ans = M.run
   t_fn = :os.system_time :millisecond
   IO.puts "#{(t_fn - t_st)/1000} seconds"
   # IO.puts String.replace(to_string(__MODULE__),"Elixir.","")
   mname = to_string(__MODULE__)
   IO.puts mname
   IO.puts "\nProblem " <> String.slice(to_string(__MODULE__),String.length(mname)-3,3) <> ":\t#{ans}"
   IO.puts "\nElapsed Time:\t#{(t_fn - t_st)/1000} seconds"
end
