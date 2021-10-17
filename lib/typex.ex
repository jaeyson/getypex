defprotocol Typex do
  @moduledoc since: "0.1.0"
  @fallback_to_any true

  @spec check(term) :: String.t()
  def check(term)
end

defimpl Typex, for: Tuple do
  def check(_tuple), do: "Tuple"
end

defimpl Typex, for: Integer do
  def check(_integer), do: "Integer"
end

defimpl Typex, for: Float do
  def check(_float), do: "Float"
end

defimpl Typex, for: Reference do
  def check(_reference), do: "Reference"
end

defimpl Typex, for: PID do
  def check(_pid), do: "PID"
end

defimpl Typex, for: Port do
  def check(_port), do: "Port"
end

defimpl Typex, for: Map do
  def check(_map), do: "Map"
end

defimpl Typex, for: [Date, Time, DateTime, NaiveDateTime] do
  def check(_), do: to_string(@for) |> String.replace("Elixir.", "")
end

defimpl Typex, for: Atom do
  def check(atom) when is_boolean(atom), do: "Atom (Boolean)"

  def check(atom) do
    atom
    |> :code.get_object_code()
    |> check_atom(atom)
  end

  defp check_atom({_, _, _}, _atom), do: "Atom (Module)"

  defp check_atom(:error, atom) do
    case match?("Elixir." <> _, Atom.to_string(atom)) do
      true ->
        "Atom (Unknown Module)"

      false ->
        "Atom"
    end
  end
end

defimpl Typex, for: BitString do
  def check(bitstring) do
    cond do
      is_binary(bitstring) and String.printable?(bitstring) -> "String (UTF-8)"
      is_binary(bitstring) and String.valid?(bitstring) -> "String (UTF-8 non-printable)"
      is_binary(bitstring) -> "Binary"
      is_bitstring(bitstring) -> "Bitstring"
    end
  end
end

defimpl Typex, for: List do
  def check(list) do
    cond do
      list == [] -> "List (Empty)"
      List.ascii_printable?(list) -> "List (Charlist)"
      Keyword.keyword?(list) -> "List (Keyword list)"
      List.improper?(list) -> "List (Improper list)"
      true -> "List"
    end
  end
end

defimpl Typex, for: Function do
  def check(function) do
    info = Function.info(function)

    case info[:type] === :external and info[:env] === [] do
      true ->
        "Function (Named)"

      false ->
        "Function (Anonymous)"
    end
  end
end

defimpl Typex, for: Any do
  def check(_struct), do: "Structs"
end
