defmodule IdenticonTest do
  use ExUnit.Case
  doctest Identicon

  test "mirror_row returns a mirrored list" do
    assert [1,2,3,2,1]== Identicon.mirror_row([1,2,3])
  end

  test "pick_colour returns a image struct with a colour set" do
  	image = %Identicon.Image{hex: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]}
  	expected_result = %Identicon.Image{colour: {1, 2, 3}, grid: nil, hex: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], pixel_map: nil}
    assert expected_result == Identicon.pick_colour(image)
  end

  test "hash_input returns the md5 hash of the input" do
  	input = "┬─┬ノ( º _ ºノ)"
  	expected_result = :crypto.hash(:md5, input) |> :binary.bin_to_list
  	%Identicon.Image{hex: output} = Identicon.hash_input(input)
    assert expected_result == output
  end

end
