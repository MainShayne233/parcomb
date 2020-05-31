import maybe.{Just, Nothing}
import parsable.{Parsable}

pub type Element {
  Element(
    name: String,
    attributes: List(tuple(String, String)),
    children: List(Element),
  )
}

pub fn the_letter_a(
  input: Parsable,
) -> Result(tuple(Parsable, Parsable), Parsable) {
  case parsable.chop_head(input) {
    Just(tuple(head, rest)) -> Ok(tuple(rest, head))
    Nothing -> Error(input)
  }
}
