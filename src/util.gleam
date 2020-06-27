import gleam/string

pub fn is_alphanumeric(char: String) -> Bool {
  let lowered = string.lowercase(char)

  lowered == "a" || lowered == "b" || lowered == "c" || lowered == "d" || lowered == "e" || lowered == "f" || lowered == "g" || lowered == "h" || lowered == "i" || lowered == "j" || lowered == "k" || lowered == "l" || lowered == "m" || lowered == "n" || lowered == "o" || lowered == "p" || lowered == "q" || lowered == "r" || lowered == "s" || lowered == "t" || lowered == "u" || lowered == "v" || lowered == "w" || lowered == "x" || lowered == "y" || lowered == "z"
}
