import parcomb
import gleam/should
import parsable.{Parsable}

pub fn the_letter_a_test() {
  let ok_input = Parsable("a orange")
  let error_input = Parsable("some orange")

  parcomb.the_letter_a(ok_input)
  |> should.equal(Ok(tuple(Parsable(" orange"), Parsable("a"))))

  parcomb.the_letter_a(error_input)
  |> should.equal(Error(Parsable("some orange")))
}

pub fn match_literal_test() {
  let ok_input = Parsable("Hello, world!")
  let error_input = Parsable("Goodbye, world!")

  let parser = parcomb.match_literal(Parsable("Hello"))

  parser(ok_input)
  |> should.equal(Ok(tuple(Parsable(", world!"), Parsable("Hello"))))

  parser(error_input)
  |> should.equal(Error(Parsable("Goodbye, world!")))
}
