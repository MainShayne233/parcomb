import parcomb.{Attribute, Element}
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
  let ok_numbers_input = Parsable("cool5beans, hi")
  let error_input = Parsable("!Nope")
  let error_numbers_input = Parsable("5beans")

  parcomb.identifier(ok_input)
  |> should.equal(Ok(tuple(Parsable(", hi"), Parsable("cool-beans"))))

  parcomb.identifier(ok_numbers_input)
  |> should.equal(Ok(tuple(Parsable(", hi"), Parsable("cool5beans"))))

  parcomb.identifier(error_input)
  |> should.equal(Error(Parsable("!Nope")))

  parcomb.identifier(error_numbers_input)
  |> should.equal(Error(Parsable("5beans")))
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

pub fn map_test() {
  let ok_input = Parsable("ident rest")
  let error_input = Parsable("!nope")

  let parser = parcomb.map(parcomb.identifier, parsable.to_string)

  parser(ok_input)
  |> should.equal(Ok(tuple(Parsable(" rest"), "ident")))

  parser(error_input)
  |> should.equal(Error(Parsable("!nope")))
}

pub fn left_test() {
  let ok_input = Parsable("<ident rest")
  let error_input = Parsable("!nope")

  let parser = parcomb.left(
    parcomb.match_literal(Parsable("<")),
    parcomb.identifier,
  )

  parser(ok_input)
  |> should.equal(Ok(tuple(Parsable(" rest"), Parsable("<"))))

  parser(error_input)
  |> should.equal(Error(Parsable("!nope")))
}

pub fn right_test() {
  let ok_input = Parsable("<ident rest")
  let error_input = Parsable("!nope")

  let parser = parcomb.right(
    parcomb.match_literal(Parsable("<")),
    parcomb.identifier,
  )

  parser(ok_input)
  |> should.equal(Ok(tuple(Parsable(" rest"), Parsable("ident"))))

  parser(error_input)
  |> should.equal(Error(Parsable("!nope")))
}

pub fn one_or_more_test() {
  let one_input = Parsable("< rest")
  let more_input = Parsable("<<< rest")
  let error_input = Parsable("!nope")

  let parser = parcomb.match_literal(Parsable("<"))
    |> parcomb.one_or_more()

  parser(one_input)
  |> should.equal(Ok(tuple(Parsable(" rest"), [Parsable("<")])))

  parser(more_input)
  |> should.equal(
    Ok(tuple(Parsable(" rest"), [Parsable("<"), Parsable("<"), Parsable("<")])),
  )

  parser(error_input)
  |> should.equal(Error(Parsable("!nope")))
}

pub fn zero_or_more_test() {
  let zero_input = Parsable(" rest")
  let more_input = Parsable("<<< rest")

  let parser = parcomb.match_literal(Parsable("<"))
    |> parcomb.zero_or_more()

  parser(zero_input)
  |> should.equal(Ok(tuple(Parsable(" rest"), [])))

  parser(more_input)
  |> should.equal(
    Ok(tuple(Parsable(" rest"), [Parsable("<"), Parsable("<"), Parsable("<")])),
  )
}

pub fn any_char_test() {
  let ok_input = Parsable("! rest")
  let error_input = Parsable("")

  parcomb.any_char(ok_input)
  |> should.equal(Ok(tuple(Parsable(" rest"), Parsable("!"))))

  parcomb.any_char(error_input)
  |> should.equal(Error(Parsable("")))
}

pub fn pred_test() {
  let ok_input = Parsable("omg")
  let error_input = Parsable("lol")

  let parser = parcomb.pred(
    parcomb.any_char,
    fn(result) { result == Parsable("o") },
  )

  parser(ok_input)
  |> should.equal(Ok(tuple(Parsable("mg"), Parsable("o"))))

  parser(error_input)
  |> should.equal(Error(Parsable("lol")))
}

pub fn whitespace_char_test() {
  let ok_input = Parsable(" hi")
  let error_input = Parsable("hi")

  let parser = parcomb.whitespace_char()

  parser(ok_input)
  |> should.equal(Ok(tuple(Parsable("hi"), Parsable(" "))))

  parser(error_input)
  |> should.equal(Error(Parsable("hi")))
}

pub fn space1_test() {
  let ok_one_input = Parsable(" hi")
  let ok_many_input = Parsable("   hi")
  let error_input = Parsable("hi")

  let parser = parcomb.space1()

  parser(ok_one_input)
  |> should.equal(Ok(tuple(Parsable("hi"), [Parsable(" ")])))

  parser(ok_many_input)
  |> should.equal(
    Ok(tuple(Parsable("hi"), [Parsable(" "), Parsable(" "), Parsable(" ")])),
  )

  parser(error_input)
  |> should.equal(Error(Parsable("hi")))
}

pub fn space0_test() {
  let ok_zero_input = Parsable("hi")
  let ok_one_input = Parsable(" hi")
  let ok_many_input = Parsable("   hi")

  let parser = parcomb.space0()

  parser(ok_zero_input)
  |> should.equal(Ok(tuple(Parsable("hi"), [])))

  parser(ok_one_input)
  |> should.equal(Ok(tuple(Parsable("hi"), [Parsable(" ")])))

  parser(ok_many_input)
  |> should.equal(
    Ok(tuple(Parsable("hi"), [Parsable(" "), Parsable(" "), Parsable(" ")])),
  )
}

pub fn quoted_string_test() {
  let ok_input = Parsable("\"hello!\" more")
  let error_input = Parsable("\"hello!")

  let parser = parcomb.quoted_string()

  parser(ok_input)
  |> should.equal(Ok(tuple(Parsable(" more"), Parsable("hello!"))))

  parser(error_input)
  |> should.equal(Error(Parsable("")))
}

pub fn attribute_pair_test() {
  let ok_input = Parsable("key=\"value\" more")
  let error_input = Parsable("key=")

  let parser = parcomb.attribute_pair()

  parser(ok_input)
  |> should.equal(
    Ok(tuple(Parsable(" more"), tuple(Parsable("key"), Parsable("value")))),
  )

  parser(error_input)
  |> should.equal(Error(Parsable("")))
}

pub fn attributes_test() {
  let ok_zero_input = Parsable(" more")
  let ok_one_input = Parsable(" key=\"value\" more")
  let ok_many_input = Parsable(" a=\"b\" c=\"d\" e=\"f\" more")

  let parser = parcomb.attributes()

  parser(ok_zero_input)
  |> should.equal(Ok(tuple(Parsable(" more"), [])))

  parser(ok_one_input)
  |> should.equal(
    Ok(tuple(Parsable(" more"), [tuple(Parsable("key"), Parsable("value"))])),
  )

  parser(ok_many_input)
  |> should.equal(
    Ok(
      tuple(
        Parsable(" more"),
        [
          tuple(Parsable("a"), Parsable("b")),
          tuple(Parsable("c"), Parsable("d")),
          tuple(Parsable("e"), Parsable("f")),
        ],
      ),
    ),
  )
}

pub fn element_start_test() {
  let ok_no_attrs_input = Parsable("<elem more")
  let ok_one_attr_input = Parsable("<elem a=\"b\" more")
  let ok_many_attrs_input = Parsable("<elem a=\"b\" c=\"d\" e=\"f\" more")
  let error_input = Parsable("nope")

  let parser = parcomb.element_start()

  parser(ok_no_attrs_input)
  |> should.equal(Ok(tuple(Parsable(" more"), tuple(Parsable("elem"), []))))

  parser(ok_one_attr_input)
  |> should.equal(
    Ok(
      tuple(
        Parsable(" more"),
        tuple(Parsable("elem"), [tuple(Parsable("a"), Parsable("b"))]),
      ),
    ),
  )

  parser(ok_many_attrs_input)
  |> should.equal(
    Ok(
      tuple(
        Parsable(" more"),
        tuple(
          Parsable("elem"),
          [
            tuple(Parsable("a"), Parsable("b")),
            tuple(Parsable("c"), Parsable("d")),
            tuple(Parsable("e"), Parsable("f")),
          ],
        ),
      ),
    ),
  )

  parser(error_input)
  |> should.equal(Error(Parsable("nope")))
}

pub fn single_element_test() {
  let ok_no_attrs_input = Parsable("<elem/> more")
  let ok_one_attr_input = Parsable("<elem a=\"b\"/> more")
  let ok_many_attrs_input = Parsable("<elem a=\"b\" c=\"d\" e=\"f\"/> more")
  let error_input = Parsable("nope")

  let parser = parcomb.single_element()

  parser(ok_no_attrs_input)
  |> should.equal(Ok(tuple(Parsable(" more"), Element("elem", [], []))))

  parser(ok_one_attr_input)
  |> should.equal(
    Ok(tuple(Parsable(" more"), Element("elem", [Attribute("a", "b")], []))),
  )

  parser(ok_many_attrs_input)
  |> should.equal(
    Ok(
      tuple(
        Parsable(" more"),
        Element(
          "elem",
          [Attribute("a", "b"), Attribute("c", "d"), Attribute("e", "f")],
          [],
        ),
      ),
    ),
  )

  parser(error_input)
  |> should.equal(Error(Parsable("nope")))
}

pub fn open_element_test() {
  let ok_no_attrs_input = Parsable("<elem> more")
  let ok_one_attr_input = Parsable("<elem a=\"b\"> more")
  let ok_many_attrs_input = Parsable("<elem a=\"b\" c=\"d\" e=\"f\"> more")
  let error_input = Parsable("nope")

  let parser = parcomb.open_element()

  parser(ok_no_attrs_input)
  |> should.equal(Ok(tuple(Parsable(" more"), Element("elem", [], []))))

  parser(ok_one_attr_input)
  |> should.equal(
    Ok(tuple(Parsable(" more"), Element("elem", [Attribute("a", "b")], []))),
  )

  parser(ok_many_attrs_input)
  |> should.equal(
    Ok(
      tuple(
        Parsable(" more"),
        Element(
          "elem",
          [Attribute("a", "b"), Attribute("c", "d"), Attribute("e", "f")],
          [],
        ),
      ),
    ),
  )

  parser(error_input)
  |> should.equal(Error(Parsable("nope")))
}
