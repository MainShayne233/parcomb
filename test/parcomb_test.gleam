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

pub fn identifier_test() {
  let ok_input = Parsable("cool-beans, hi")
  let error_input = Parsable("!Nope")

  parcomb.identifier(ok_input)
  |> should.equal(Ok(tuple(Parsable(", hi"), Parsable("cool-beans"))))

  parcomb.identifier(error_input)
  |> should.equal(Error(Parsable("!Nope")))
}

pub fn pair_test() {
  let ok_input = Parsable("<tag stuff")
  let error_input = Parsable("tag")

  let parser = parcomb.pair(
    parcomb.match_literal(Parsable("<")),
    parcomb.identifier,
  )

  parser(ok_input)
  |> should.equal(
    Ok(tuple(Parsable(" stuff"), tuple(Parsable("<"), Parsable("tag")))),
  )

  parser(error_input)
  |> should.equal(Error(Parsable("tag")))
}
