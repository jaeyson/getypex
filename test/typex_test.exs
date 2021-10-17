defmodule TypexTest do
  use ExUnit.Case
  doctest Typex

  defmodule TestStruct do
    defstruct foo: :bar
  end

  test "checks string" do
    assert Typex.check("hello world") === "String (UTF-8)"
    assert Typex.check(<<"hello", "world", 0>>) === "String (UTF-8 non-printable)"
    assert Typex.check(<<255, 255>>) === "Binary"
    assert Typex.check(<<3::3>>) === "Bitstring"
  end

  test "checks list" do
    assert Typex.check([]) === "List (Empty)"
    assert Typex.check('abcdefg') === "List (Charlist)"
    assert Typex.check(key: :value) === "List (Keyword list)"
    assert Typex.check([1 | 2]) === "List (Improper list)"
    assert Typex.check([1, 2, 3, 4]) === "List"
  end

  test "checks atom" do
    assert Typex.check(true) === "Atom (Boolean)"
    assert Typex.check(false) === "Atom (Boolean)"
    assert Typex.check(:atom) === "Atom"
    assert Typex.check(Typex) === "Atom (Module)"
    assert Typex.check(:"Elixir.Typex") === "Atom (Module)"
    assert Typex.check(:"Elixir.Whoami") === "Atom (Unknown Module)"
    assert Typex.check(Whoami) === "Atom (Unknown Module)"
  end

  test "checks map" do
    assert Typex.check(%{key: :value}) === "Map"
    assert Typex.check(%{"key" => :value}) === "Map"
    assert Typex.check(%{1 => 2}) === "Map"
  end

  test "checks float" do
    assert Typex.check(1.23) === "Float"
  end

  test "checks integer" do
    assert Typex.check(123) === "Integer"
  end

  test "checks tuple" do
    assert Typex.check({:ok, "message"}) === "Tuple"
    assert Typex.check({:err, [reason: "message"]}) === "Tuple"
  end

  describe "checks functions" do
    test "Anonymous functions" do
      &((&1 * 3)
        |> Typex.check()
        |> Kernel.===("Function (Anonymous)")
        |> assert())
    end

    test "Named functions" do
      (&List.flatten/1)
      |> Typex.check()
      |> Kernel.===("Function (Named)")
      |> assert()
    end
  end

  test "checks time, date and naive" do
    assert Typex.check(~D[2000-01-25]) === "Date"
    assert Typex.check(~T[12:12:12]) === "Time"
    assert Typex.check(~U[2000-01-25 12:12:12Z]) === "DateTime"
    assert Typex.check(~N[2000-01-25 12:12:12]) === "NaiveDateTime"
  end

  test "checks PID" do
    assert Typex.check(spawn_link(fn -> :pid end)) === "PID"
  end

  test "checks port" do
    {:ok, port} = :gen_udp.open(0)
    :gen_udp.close(port)
    assert Typex.check(port) === "Port"
  end

  test "checks reference" do
    assert Typex.check(make_ref()) === "Reference"
  end

  test "checks structs" do
    assert Typex.check(%TestStruct{}) === "Structs"
  end
end
