defmodule Sudoku do
  @moduledoc """
  
  """

  def solve_brute(board, [x, y] \\ [-1, 0]) do
    if Board.full?(board) do
      if Board.correct?(board) do
        board
      else
        false
      end
    else
      if Board.correct?(board) do
        # Could lead to correct solution
        {:cont, [x, y]} = Board.next_empty_elem(board, [x, y])

           solve_brute(Board.put(board, [x, y], 1), [x, y])
        || solve_brute(Board.put(board, [x, y], 2), [x, y])
        || solve_brute(Board.put(board, [x, y], 3), [x, y])
        || solve_brute(Board.put(board, [x, y], 4), [x, y])
        || solve_brute(Board.put(board, [x, y], 5), [x, y])
        || solve_brute(Board.put(board, [x, y], 6), [x, y])
        || solve_brute(Board.put(board, [x, y], 7), [x, y])
        || solve_brute(Board.put(board, [x, y], 8), [x, y])
        || solve_brute(Board.put(board, [x, y], 9), [x, y])
      else
        false
      end
    end
  end
end
