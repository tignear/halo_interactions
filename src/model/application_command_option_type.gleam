import gleam/dynamic.{type DecodeErrors, type Dynamic, DecodeError, int}
import gleam/int
import gleam/result

pub type ApplicationCommandOptionType {
  SubCommand
  SubCommandGroup
  String
  Integer
  Boolean
  User
  Channel
  Role
  Mentionable
  Number
  Attachment
}

pub fn try_from_int(v: Int) -> Result(ApplicationCommandOptionType, Nil) {
  case v {
    1 -> Ok(SubCommand)
    2 -> Ok(SubCommandGroup)
    3 -> Ok(String)
    4 -> Ok(Integer)
    5 -> Ok(Boolean)
    6 -> Ok(User)
    7 -> Ok(Channel)
    8 -> Ok(Role)
    9 -> Ok(Mentionable)
    10 -> Ok(Number)
    11 -> Ok(Attachment)
    _ -> Error(Nil)
  }
}

pub fn decode(v: Dynamic) -> Result(ApplicationCommandOptionType, DecodeErrors) {
  use v <- result.try(int(v))
  use _ <- result.map_error(try_from_int(v))
  [DecodeError(expected: "Int(1-11)", found: int.to_string(v), path: [])]
}
