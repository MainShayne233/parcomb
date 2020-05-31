import gleam/string.{pop_grapheme}
import maybe.{Maybe, Just, Nothing}

pub type Parsable {
  Parsable(string: String)
}

pub fn chop_head(input: Parsable) -> Maybe(tuple(Parsable, Parsable)) {
  case pop_grapheme(input.string) {
    Ok(tuple(head, rest)) -> Just(tuple(Parsable(head), Parsable(rest)))
    _ -> Nothing
  }
}
