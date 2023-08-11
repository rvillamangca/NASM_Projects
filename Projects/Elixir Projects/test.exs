# Kernel.trunc(4.4) |> div(2) |> IO.puts
# 4.4 / 2 |> IO.puts
# Integer.gcd(4,6) |> IO.puts
# arr = Enum.into 0..10, []
# arr |> Enum.map(&(IO.write("#{&1} ")))
# IO.puts("")
# arr2 = List.duplicate("A",10);
# arr2 |> Enum.map(&(IO.write("#{&1} ")))
# IO.puts("")
# arr3 = Enum.to_list(1..10)
# arr3 |> Enum.map(&(IO.write("#{&1} ")))
# IO.puts("")
# arr4 = arr3 |> Enum.map(&(&1 * &1))
# arr4 |> Enum.each(&(IO.write("#{&1} ")))
# IO.puts("")
# arr3 |> Enum.map(&(&1 * &1)) |> Enum.sum |> IO.puts
# IO.puts("")
# arr3 = (arr3 ++ [11]) -- [2]
# inspect(arr3) |> IO.puts
#
# x = 5
# cond do
#    x == 3 ->
#       y = 5
#       IO.puts y
#    x == 2 ->
#       y = 7
#       IO.puts y
#    true ->
#       IO.puts 100
# end
# IO.puts(Kernel.trunc(:math.sqrt(22)))

# defmodule MyAgent do
#    def init(arr) do
#       Agent.start_link(fn -> Enum.map(arr, &(&1*2)) end, name: :pid)
#    end
#    def change(n) do
#       Agent.update(:pid, fn(arr) ->
#          k = n * 2
#          [k|arr]
#       end)
#    end
#    def update(pos,n) do
#       Agent.update(:pid, fn(arr) ->
#          arr |> Enum.map_every(pos,fn _ -> n end)
#       end)
#    end
#    def prn do
#       Agent.get(:pid, fn(arr) -> arr end) |> inspect |> IO.puts
#    end
# end
#
# MyAgent.init([1,0])

# MyAgent.change(2)
# MyAgent.change(3)
# MyAgent.change(4)
# MyAgent.change(5)
# MyAgent.update(2,100)
# for i <- 2..10, do: MyAgent.change(i)
# Enum.to_list(2..100) |> Enum.each(&(MyAgent.change(&1)))
# MyAgent.prn

# a = Enum.to_list(0..10)
# a |> Enum.slice(5..length(a)-1) |> Enum.map_every(2,fn _ -> 0 end) |> inspect |> IO.puts

# a = Enum.to_list(0..10) |> List.to_tuple
#
# for n <- 0..10, do: a = put_elem(a,n,2*n)
# # a = put_elem(a,0,100)
# a |> inspect |> IO.puts

# ns = Stream.iterate(3,&(&1+2)) |> Enum.take_while(&(&1 <= 100))
# ns |> inspect |> IO.puts

# arr = :array.new(10)
# arr = :array.set(0,1,arr)
# lst = :array.to_list(arr)
# lst = [2,4]
# lst = Enum.into(lst, [100], fn x -> if x == 2, do: x * 3, else: x end)
# inspect(lst) |> IO.puts


# lst = (1..10) |> Enum.to_list
# ls = lst |> Enum.filter(&(&1<5))
# ls |> IO.inspect

# lst = Stream.iterate(0, &(&1+3)) |> Enum.take(10)
# Enum.intersperse(lst, List.duplicate(0,2)) |> List.flatten |> IO.inspect

# lim = 1_000_000
# d = 3
# nums1 = List.duplicate(1,lim)
# # nums1 |> IO.inspect
#
# nums2 = List.duplicate(0,div(lim,d)+2) |> Enum.intersperse(List.duplicate(1,d-1)) |> List.flatten |> Enum.drop(1) |> Enum.take(lim)
# # nums2 |> IO.inspect
#
# t_st = :os.system_time :millisecond
# nums3 = nums1 |> Enum.zip(nums2) |> Enum.map(fn {k,v} -> k && v end)
# nums3 |> IO.inspect
# t_fn = :os.system_time :millisecond
# IO.puts "\n#{(t_fn - t_st)/1000} seconds"

# Stream.iterate(0, &(&1+3)) |> Enum.take(10) |> Enum.intersperse(List.duplicate(0,2)) |> List.flatten |> IO.inspect

# (1..50)|> Task.async_stream(&(&1*3)) |> Enum.map(&(elem(&1,1))) |> IO.inspect
# (3..51) |> Enum.drop_while(&(&1<25)) |> Enum.drop_every(5) |> IO.inspect

# x = 6
# cond do
#    x == 5 ->
#       "x = 5" |> IO.puts
#       10 |> IO.puts
#    true ->
#       "x != 5" |> IO.puts
#       6 |> IO.puts
# end
# x |> IO.puts
#
# # set = Stream.iterate(2,&(&1+2)) |> Enum.take_while(&(&1<100)) |> MapSet.new
# set = (1..div(100,2)) |> MapSet.new(&(&1*2)) #|> Enum.sort
# set |> IO.inspect


# defmodule Numbers do
#    def print_nums do
#       Enum.map(:ets.tab2list(:nums), fn {_,i} -> i end) |> Enum.sort |> IO.inspect
#    end
#    def update_nums(num) do
#       :ets.insert(:nums,{num,num})
#    end
#    def create_nums do
#       :ets.new(:nums, [:set, :named_table])
#       (1..10) |> Enum.each(&(:ets.insert(:nums,{&1,&1})))
#    end
# end
#
# Numbers.create_nums
# Numbers.update_nums(11)
# Numbers.print_nums

require Integer

# arr = (1..100) |> Enum.to_list
# arr = for i <- arr, do: if Integer.is_even(i), do: 0, else: i
arr = Stream.iterate(1,fn i -> if Integer.is_even(i+1), do: 0, else: i+1 end) |> Enum.take(10)
arr |> IO.inspect
