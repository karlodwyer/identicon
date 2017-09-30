defmodule Identicon.Main do

  @moduledoc """
  This module includes everything to run this project as a command line application.
  """

  def main(args) do
  args
  |> parse_args
  |> do_process 
  end

  def parse_args(args) do
  options = OptionParser.parse(args)
  
  case options do
    {[name: name], _, _} -> IO.puts "Hello, #{name}! You're awesome!!"
    {[filename: filename],[input],_} -> Identicon.main(input, filename)
    {_,[input],_} -> Identicon.main(input)
    _ -> :help
  end
  end

  def do_process(:help) do
  IO.puts """
  identicon: Generate github inspired identicons,

  Usage:
  identicon YOURNAME
  \tCreates an identicon using YOURNAME as the input \n\tand saves it to MyIdenticon.png
  identicon YOURNAME --filename YOURFILE
  \tCreates an identicon using YOURNAME as the input \n\tand saves it to YOURFILE.png
  identicon --help
  \tPrints this help message
  """
  end

  def do_process(:ok) do
  IO.puts "OK"
  end

end
