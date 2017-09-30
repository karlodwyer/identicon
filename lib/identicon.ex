defmodule Identicon do
  @moduledoc """
  This module is based on one of the projects from Stephen Grider's awesome Udemy course 
  "The Complete Elixir and Phoenix Bootcamp", I've stayed faithful to the idea, but I made a few small changes.

  """

  @doc """
  The main method, takes an input string and a filename, if you don't supply one, it defualts to MyIdenticon.

  """
  def main(input, filename \\ "MyIdenticon") do
    input
    |> hash_input
    |> pick_colour
    |> build_grid
    |> build_pixel_map
    |> draw_image
    |> save_image(filename)
  end

  @doc """
  Takes an input string and returns a `Identicon.Image` struct with the md5 hash of the input.

  ## Examples

      iex> Identicon.hash_input("Hello World")
      %Identicon.Image{colour: nil, grid: nil, hex: [177, 10, 141, 177, 100, 224, 117, 65, 5, 183, 169, 155, 231, 46, 63, 229], pixel_map: nil}


  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  @doc """
  Takes `Identicon.Image` struct with a valid hex field and returns a new struct with a colour field.

  ## Examples

      iex> image = %Identicon.Image{hex: [1,2,3]}
      iex> Identicon.pick_colour(image)
      %Identicon.Image{colour: {1, 2, 3}, grid: nil, hex: [1, 2, 3], pixel_map: nil}

  """
  def pick_colour(%Identicon.Image{hex: [r,g,b| _tail]} = image) do
    %Identicon.Image{image |colour: {r,g,b}}
  end

  @doc """
  Takes an `Identicon.Image` struct with a valid hex field and returns a new copy of the input struct with a grid field.
  This is used to take the hashed input string and make a grid. The grid is later turned into a pixel map.

  ## Examples

      iex> image = %Identicon.Image{hex: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]}
      iex> Identicon.build_grid(image)
      %Identicon.Image{colour: nil, grid: [{2, 1}, {2, 3}, {4, 5}, {6, 7}, {4, 9}, {8, 11}, {8, 13}, {10, 15}, {12, 17}, {10, 19}, {14, 21}, {14, 23}], hex: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16], pixel_map: nil}

  """
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid = 
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index
      |> Enum.filter(fn({code, _index}) -> rem(code, 2) == 0 end)
  
    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Takes an list and returns a new list with second and first element append to the end

  ## Examples

      iex> Identicon.mirror_row([1,2,3])
      [1, 2, 3, 2, 1]

  """
  def mirror_row([first,second | _tail] = row) do
    row ++ [second, first]
  end

  @doc """
  Takes an `Identicon.Image` struct with a gird field and returns a new copy of the input struct with a pixel_map.
  This pixel map is used to draw the image.

  ## Examples

      iex> image = %Identicon.Image{colour: nil, grid: [{2, 1}, {2, 3}, {4, 5}, {6, 7}, {4, 9}, {8, 11}, {8, 13}, {10, 15}, {12, 17}, {10, 19}, {14, 21}, {14, 23}], hex: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16], pixel_map: nil}
      iex> Identicon.build_pixel_map(image)
      %Identicon.Image{colour: nil, grid: [{2, 1}, {2, 3}, {4, 5}, {6, 7}, {4, 9}, {8, 11}, {8, 13}, {10, 15}, {12, 17}, {10, 19}, {14, 21}, {14, 23}], hex: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16], pixel_map: [{{75, 25}, {125, 75}}, {{175, 25}, {225, 75}}, {{25, 75}, {75, 125}}, {{125, 75}, {175, 125}}, {{225, 75}, {275, 125}}, {{75, 125}, {125, 175}}, {{175, 125}, {225, 175}}, {{25, 175}, {75, 225}}, {{125, 175}, {175, 225}}, {{225, 175}, {275, 225}}, {{75, 225}, {125, 275}}, {{175, 225}, {225, 275}}]}

  """

  def build_pixel_map(%Identicon.Image{grid: grid} = image, border_offset \\ 25) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      horizontal = (rem(index, 5) * 50) + border_offset
      vertical = (div(index, 5) * 50) + border_offset

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}

    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
  Takes an `Identicon.Image` struct with a pixel_map and a colour and draws an image.

  """

  def draw_image(%Identicon.Image{colour: colour, pixel_map: pixel_map}, border_offset \\ 25) do
    image_heightwidth = 250 + (border_offset * 2)
    image = :egd.create(image_heightwidth, image_heightwidth)
    fill = :egd.color(colour)

    background = :egd.color({240,240,240})
    :egd.filledRectangle(image, {0,0}, {image_heightwidth, image_heightwidth}, background)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  @doc """
  Writes the image to disk using a filename
  """

  def save_image(image, filename) do
    File.write("#{filename}.png", image)
  end

end
