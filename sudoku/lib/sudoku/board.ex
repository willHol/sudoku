defmodule Sudoku.Board do
  @nums [1, 2, 3, 4, 5, 6, 7, 8, 9]
  @square_dim 3

  def valid_num?(1), do: true
  def valid_num?(2), do: true
  def valid_num?(3), do: true
  def valid_num?(4), do: true
  def valid_num?(5), do: true
  def valid_num?(6), do: true
  def valid_num?(7), do: true
  def valid_num?(8), do: true
  def valid_num?(9), do: true
  def valid_num?(nil), do: true
  def valid_num?(_), do: false

  def valid?(board) do
    num_columns = num_columns(board)
    num_rows = num_rows(Enum.at(board, 0))

    columns_valid = rem(Enum.count(board), 3) === 0

    if columns_valid do
      Enum.all?(board, &(Enum.count(&1) === num_columns))
      && num_rows == num_columns
    else
      false
    end
  rescue
    _ -> false
  end

  def correct?(board) do
    lines_correct?(board) && boxes_correct?(board)
  end

  def line_correct?(line) do
    {valid?, _} =
      Enum.reduce(line, {true, []}, fn el, acc ->
        case acc do
          {true, seen} ->
            {(!Enum.member?(seen, el) || is_nil(el)) && valid_num?(el), [el | seen]}
          any ->
            any
        end
      end)

    valid?
  end

  def lines_correct?(board) do
    Enum.all?(0..dimension(board) - 1, fn i ->
      line_correct?(ith_row(board, i)) && line_correct?(ith_column(board, i))
    end)
  end

  def box_correct?(box) do
    {truth, _} =
      Enum.reduce(List.flatten(box), {true, []}, fn el, {truth, seen} ->
        {truth && valid_num?(el) && (!Enum.member?(seen, el) || is_nil(el)), [el | seen]}
      end)

    truth
  end

  def boxes_correct?(board) do
    {truth, _} =
      Enum.reduce(1..trunc(:math.pow(dimension(board), 2)), {true, [-1, 2]}, fn _, {truth, coord} -> 
        case next_box(board, coord) do
          {:cont, [x, y]} ->
            {truth && (board |> box_at(coord) |> box_correct?()), [x, y]}
          {:halt, [x, y]} ->
            {truth, [x, y]}
        end
        
      end)

    truth
  end

  def full?(board) do
    Enum.all?(board, fn row ->
      Enum.all?(row, &(!is_nil(&1)))
    end)
  end

  def ith_row(board, i) do
    Enum.at(board, i)
  end

  def ith_column(board, i) do
    board
    |> Enum.reduce([], &([Enum.at(&1, i) | &2]))
    |> Enum.reverse()
  end

  def dimension(board), do: Enum.count(board)

  def num_rows(board) do
    Enum.count(board)
  end

  def num_columns(board) do
    Enum.count(Enum.at(board, 0))
  end

  def at(board, [x, y]) do
    Enum.at(Enum.at(board, y), x)
  end

  def put(board, [x, y], el) do
    replace(board, y, replace(ith_row(board, y), x, el))
  end

  defp replace(list, i, el) do
  Enum.slice(list, 0, i) ++
  [el] ++
  Enum.slice(list, i + 1, Enum.count(list))
  end

  def box_at(board, [x, y]) do
    Enum.map(y - 2..y + @square_dim - 3, fn y ->
      Enum.slice(ith_row(board, y), x - 2, @square_dim)
    end)
  end

  def next_elem(board, [x, y], inc \\ 1) do
    cond do
      x + inc < num_columns(board) ->
        {:cont, [x + inc, y]}

      y + inc < num_rows(board) ->
        {:cont, [inc - 1, y + inc]}
      true ->
        {:halt, [x, y]}
    end
  end

  def next_empty_elem(board, [x, y]) do
    case next_elem(board, [x, y]) do
      {:cont, [x, y]} ->
        if (is_nil(at(board, [x, y]))) do
          {:cont, [x, y]}
        else
          next_empty_elem(board, [x, y])
        end
      {:halt, [x, y]} ->
        {:halt, [x, y]}
    end
  end

  # [x, y] represents the bottom right corner of the square.
  def next_box(board, [x, y]) do
    next_elem(board, [x, y], @square_dim)
  end
end