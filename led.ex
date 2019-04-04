defmodule Display do
   @charmap  System.get_env("charmap") || "/Users/leiding/printPlay/HZK16"

   def display(char) do
      charcode = getCharcode(char, @charmap)
      show(charcode)
   end

   def show(""), do: IO.puts "EOF"

   def show(<<a,b,content::binary>>) do
      (generate8bitList(a) ++ generate8bitList(b))
      |> displayDriver
      show(content)
   end

   def displayDriver(list) do
      list |> Enum.map( fn x ->
         if x == 0 do
            IO.write("○ ")
         else
            IO.write("● ")
         end
      end)
      IO.write("\n")
   end

   defp generate8bitList(num) do
      num = Integer.digits(num,2)
      num_len = length(num)
      if num_len < 8 do
         List.duplicate(0,8- num_len) ++ num
      else
         num
      end
   end

   def getCharcode(char,charMap) do
      <<qh, wh>> = :iconv.convert("utf-8", "GB2312",char)
      qh = qh - 0xa0
      wh = wh - 0xa0
      offset = ( 94*(qh-1) + (wh-1) ) * 32
      case :file.open(charMap, [:read, :binary]) do
         {:ok, file} ->
            :file.position(file,offset)
            {:ok, content} = :file.read(file,32)
            :file.close(file)
            content
         {:error,_} ->
            IO.puts "cant open the #{@charmap}"
      end

   end
end