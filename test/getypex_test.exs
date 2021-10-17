defmodule GetypexTest do
  use ExUnit.Case
  doctest Getypex

  defmodule TestStruct do
    defstruct foo: :bar
  end

  test "checks string" do
    assert Getypex.check("hello world") === "String (UTF-8)"
    assert Getypex.check(<<"hello", "world", 0>>) === "String (UTF-8 non-printable)"
    assert Getypex.check(<<255, 255>>) === "Binary"
    assert Getypex.check(<<3::3>>) === "Bitstring"
  end

  test "checks list" do
    assert Getypex.check([]) === "List (Empty)"
    assert Getypex.check('abcdefg') === "List (Charlist)"
    assert Getypex.check(key: :value) === "List (Keyword list)"
    assert Getypex.check([1 | 2]) === "List (Improper list)"
    assert Getypex.check([1, 2, 3, 4]) === "List"
  end

  test "checks atom" do
    assert Getypex.check(true) === "Atom (Boolean)"
    assert Getypex.check(false) === "Atom (Boolean)"
    assert Getypex.check(:atom) === "Atom"
    assert Getypex.check(Getypex) === "Atom (Module)"
    assert Getypex.check(:"Elixir.Getypex") === "Atom (Module)"
    assert Getypex.check(:"Elixir.Whoami") === "Atom (Unknown Module)"
    assert Getypex.check(Whoami) === "Atom (Unknown Module)"
  end

  test "checks map" do
    assert Getypex.check(%{key: :value}) === "Map"
    assert Getypex.check(%{"key" => :value}) === "Map"
    assert Getypex.check(%{1 => 2}) === "Map"
  end

  test "checks float" do
    assert Getypex.check(1.23) === "Float"
  end

  test "checks integer" do
    assert Getypex.check(123) === "Integer"
  end

  test "checks tuple" do
    assert Getypex.check({:ok, "message"}) === "Tuple"
    assert Getypex.check({:err, [reason: "message"]}) === "Tuple"
  end

  describe "checks functions" do
    test "Anonymous functions" do
      &((&1 * 3)
        |> Getypex.check()
        |> Kernel.===("Function (Anonymous)")
        |> assert())
    end

    test "Named functions" do
      (&List.flatten/1)
      |> Getypex.check()
      |> Kernel.===("Function (Named)")
      |> assert()
    end
  end

  test "checks time, date and naive" do
    assert Getypex.check(~D[2000-01-25]) === "Date"
    assert Getypex.check(~T[12:12:12]) === "Time"
    assert Getypex.check(~U[2000-01-25 12:12:12Z]) === "DateTime"
    assert Getypex.check(~N[2000-01-25 12:12:12]) === "NaiveDateTime"
  end

  test "checks PID" do
    assert Getypex.check(spawn_link(fn -> :pid end)) === "PID"
  end

  test "checks port" do
    {:ok, port} = :gen_udp.open(0)
    :gen_udp.close(port)
    assert Getypex.check(port) === "Port"
  end

  test "checks reference" do
    assert Getypex.check(make_ref()) === "Reference"
  end

  test "checks structs" do
    assert Getypex.check(%TestStruct{}) === "Structs"
  end
end
