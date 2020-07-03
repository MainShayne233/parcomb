import gleam/string

pub fn is_alphabetic(char: String) -> Bool {
  let lowered = string.lowercase(char)

  lowered == "a" || lowered == "b" || lowered == "c" || lowered == "d" || lowered == "e" || lowered == "f" || lowered == "g" || lowered == "h" || lowered == "i" || lowered == "j" || lowered == "k" || lowered == "l" || lowered == "m" || lowered == "n" || lowered == "o" || lowered == "p" || lowered == "q" || lowered == "r" || lowered == "s" || lowered == "t" || lowered == "u" || lowered == "v" || lowered == "w" || lowered == "x" || lowered == "y" || lowered == "z"
}

pub fn is_alphanumeric(char: String) -> Bool {
  let lowered = string.lowercase(char)

  is_alphabetic(
    lowered,
  ) || lowered == "0" || lowered == "1" || lowered == "2" || lowered == "3" || lowered == "4" || lowered == "5" || lowered == "6" || lowered == "7" || lowered == "8" || lowered == "9"
}
