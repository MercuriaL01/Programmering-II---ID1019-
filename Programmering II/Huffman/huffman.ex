defmodule Huffman do
  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def text() do
    'this is something that we should encode'
  end

  def bench() do
    {time, _} = :timer.tc(Huffman, :testBench, [sample()])
    IO.puts("Time sample: #{time} microseconds, Number of chars: #{Enum.count(sample())}")
    {time, _} = :timer.tc(Huffman, :testBench, [text()])
    IO.puts("Time text: #{time} microseconds, Number of chars: #{Enum.count(text())}")
    {time, _} = :timer.tc(Huffman, :testBench, [read("kallocain.txt")])

    IO.puts(
      "Time kallocain: #{time} microseconds, Number of chars: #{Enum.count(read("kallocain.txt"))}"
    )
  end

  def read(file) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, :all)
    File.close(file)

    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, list, _} ->
        list

      list ->
        list
    end
  end

  def test do
    sample = sample()
    tree = tree(sample)
    encode = encode_table(tree)
    decode = decode_table(tree)
    text = text()
    seq = encode(text, encode)
    decode(seq, decode)
  end

  def testBench(n) do
    sample = n
    tree = tree(sample)
    encode = encode_table(tree)
    decode = decode_table(tree)
    text = n
    seq = encode(text, encode)
    decode(seq, decode)
  end

  def decode_table(tree) do
    encode_table(tree)
  end

  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  def freq(sample) do
    freq(sample, [])
  end

  def freq([], freq) do
    freq
  end

  def freq([char | rest], freq) do
    freq(rest, addToFreq(char, freq))
  end

  def addToFreq(char, []) do
    [{char, 1}]
  end

  def addToFreq(char, _freq = [{listChar, listFreq} | tail]) do
    cond do
      char == listChar ->
        [{listChar, listFreq + 1} | tail]

      true ->
        [{listChar, listFreq} | addToFreq(char, tail)]
    end
  end

  def huffman([tuple | []]) do
    tuple
  end

  def huffman(freq = [head | tail]) do
    s = smallest(tail, head)
    newFreq = remove(freq, s, [])
    [newHead | newTail] = newFreq
    s2 = smallest(newTail, newHead)
    newestFreq = remove(newFreq, s2, [])
    {_, valueOne} = s
    {_, valueTwo} = s2
    node = {{s, s2}, valueOne + valueTwo}
    returnFreq = [node | newestFreq]
    huffman(returnFreq)
  end

  def smallest([], s) do
    s
  end

  def smallest(_freq = [head | tail], s = {_char, value}) do
    {_, firstVal} = head

    if value <= firstVal do
      smallest(tail, s)
    else
      smallest(tail, head)
    end
  end

  def remove([], [], newFreq) do
    newFreq
  end

  def remove(_freq = [head | tail], s, newFreq) do
    cond do
      head == s ->
        tail ++ newFreq

      true ->
        remove(tail, s, [head | newFreq])
    end
  end

  def encode_table(tree) do
    encode_table(tree, [])
  end

  def encode_table({left, right}, table) do
    leftEncode = encode_table(left, [0 | table])
    rightEncode = encode_table(right, [1 | table])
    leftEncode ++ rightEncode
  end

  def encode_table(node, table) do
    [{node, reverse(table, [])}]
  end

  def reverse([], result) do
    result
  end

  def reverse([head | tail], result) do
    reverse(tail, [head | result])
  end

  def encode([], _) do
    []
  end

  def encode(_text = [head | tail], table) do
    charToCode(head, table) ++ encode(tail, table)
  end

  def charToCode(char, _table = [{char, code} | _tail]) do
    code
  end

  def charToCode(char, _table = [{_otherChar, _code} | tail]) do
    charToCode(char, tail)
  end

  def decode([], _) do
    []
  end

  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end

  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)

    case List.keyfind(table, code, 1) do
      {char, _value} ->
        {char, rest}

      nil ->
        decode_char(seq, n + 1, table)
    end
  end
end
