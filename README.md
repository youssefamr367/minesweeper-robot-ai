# AI Module for a Minesweeper Robot

A breadth-first search solver in Haskell. A robot starts somewhere on a 4 × 4 grid with a list of mine cells to collect; the module searches for a sequence of moves that collects every mine and returns that sequence as a list of actions.

Written as a functional programming course project.

## The model

```haskell
type Cell = (Int, Int)
data MyState = Null | S Cell [Cell] String MyState
```

A state holds the robot's current cell, the mines still to collect, the action that produced it, and the state it came from — so the path can be reconstructed by walking the parent chain back to the start. `Null` represents an illegal move, which keeps the move functions total instead of partial.

## Actions

| Function | Effect | Fails when |
| --- | --- | --- |
| `up` | Row − 1 | Already on row 0 |
| `down` | Row + 1 | Already on row 3 |
| `left` | Column − 1 | Already on column 0 |
| `right` | Column + 1 | Already on column 3 |
| `collect` | Removes the current cell from the mine list | The robot is not standing on a mine |

Each returns `Null` rather than erroring, and `nextMyStates` filters those out:

```haskell
nextMyStates x = filter (/= Null) [up x, down x, left x, right x, collect x]
```

## The search

`search` expands the whole current frontier at once with `nextMyStates_array`, checking `isGoal_array` before each expansion — a breadth-first search, so the first solution found is a shortest one. A state is a goal when its mine list is empty.

`constructSolution` walks the parent chain and reverses it into forward order, stopping at the start state, whose action string is `""`.

## Usage

Requires GHC or GHCi.

```bash
ghci AI-Module-for-a-Minesweeper-Robot.hs
```

`solve` takes the robot's starting cell and the list of mine cells, and returns the actions:

```haskell
ghci> solve (0,0) [(0,1),(1,1)]
["right","collect","down","collect"]
```

## Notes

- The grid bounds are hardcoded to 4 × 4 in the move functions, by pattern-matching on rows and columns `0` and `3`.
- There is no visited set, so the frontier grows quickly; the search is correct but exponential in the depth of the solution.
- `remove_one` raises `error "Element not found!"` if asked to remove a cell that is not in the list, which `collect` prevents by checking membership first.
