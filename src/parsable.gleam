import gleam/string.{length, pop_grapheme, to_graphemes}
import gleam/list
import maybe.{Just, Maybe, Nothing}

pub type Parsable {
  Parsable(string: String)
}

pub fn chop_head(input: Parsable) -> Maybe(tuple(Parsable, Parsable)) {
  case pop_grapheme(input.string) {
    Ok(tuple(head, rest)) -> Just(tuple(Parsable(head), Parsable(rest)))
    _ -> Nothing
  }
}

pub fn length(input: Parsable) -> Int {
  input
  |> to_string()
  |> string.length
}

pub fn to_string(value: Parsable) -> String {
  value.string
}

pub fn split_at(input: Parsable, index: Int) -> tuple(Parsable, Parsable) {
  let chars = to_graphemes(input.string)
  let tuple(lhs, rhs) = list.split(chars, index)
  tuple(Parsable(string.concat(lhs)), Parsable(string.concat(rhs)))
}
