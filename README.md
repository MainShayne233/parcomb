# parcomb

[![CI Status](https://github.com/MainShayne233/parcomb/workflows/test/badge.svg)](https://github.com/MainShayne233/parcomb/actions?query=workflow%3A%22test%22)

A [gleam](https://github.com/gleam-lang/gleam) implementation of the _Xcruciating Markup Language Parser_ that you build with this guide on parser combinators: [bodil.lol/parser-combinators/](https://bodil.lol/parser-combinators/).

## Example

This input:

```xml
<top label=\"Top\">
  <semi-bottom label=\"Bottom\"/>
  <middle>
      <bottom label=\"Another bottom\"/>
  </middle>
</top>
```

will get parsed as:

```rust
 Ok(
   tuple(
     Parsable(""),
     Element(
       "top",
       [Attribute("label", "Top")],
       [
         Element("semi-bottom", [Attribute("label", "Bottom")], []),
         Element(
           "middle",
           [],
           [Element("bottom", [Attribute("label", "Another bottom")], [])],
         ),
       ],
     ),
   ),
 ),
```

## Quick start

```sh
# Build the project
rebar3 compile

# Run the eunit tests
rebar3 eunit

# Run the Erlang REPL
rebar3 shell
```
