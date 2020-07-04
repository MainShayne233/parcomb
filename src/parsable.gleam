import gleam/string.{append, length, pop_grapheme, to_graphemes}
import gleam/list
import maybe.{Just, Maybe, Nothing}

pub type Parsable {
  Parsable(string: String)
}

pub fn to_string(value: Parsable) -> String {
  value.string
}

pub fn concat(lhs: Parsable, rhs: Parsable) -> Parsable {
  Parsable(append(to_string(lhs), to_string(rhs)))
}

pub fn chop_head(input: Parsable) -> Maybe(tuple(Parsable, Parsable)) {
  case pop_grapheme(to_string(input)) {
    Ok(tuple(head, rest)) -> Just(tuple(Parsable(head), Parsable(rest)))
    _ -> Nothing
  }
}

pub fn length(input: Parsable) -> Int {
  input
  |> to_string()
  |> string.length
}

pub fn split_at(input: Parsable, index: Int) -> tuple(Parsable, Parsable) {
  let tuple(
    lhs,
    rhs,
  ) = input
    |> to_string()
    |> to_graphemes()
    |> list.split(index)

  tuple(Parsable(string.concat(lhs)), Parsable(string.concat(rhs)))
}

pub fn split_while(
  input: Parsable,
  fun: fn(String) -> Bool,
) -> tuple(Parsable, Parsable) {
  let tuple(
    lhs,
    rhs,
  ) = input
    |> to_string()
    |> to_graphemes()
    |> list.split_while(fun)

  tuple(Parsable(string.concat(lhs)), Parsable(string.concat(rhs)))
}

pub fn flatten(parsables: List(Parsable)) -> Parsable {
  parsables
  |> list.reverse()
  |> list.fold(Parsable(""), concat)
}
