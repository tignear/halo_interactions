import gleam/dynamic.{type DecodeErrors, type Dynamic, DecodeError, int}
import gleam/int
import gleam/result

pub type InteractionType {
  Ping
  ApplicationCommand
  MessageComponent
  ApllicationCommandAutoComplete
  ModalSubmit
}

pub fn from_int(ty: Int) -> Result(InteractionType, Nil) {
  case ty {
    1 -> Ok(Ping)
    2 -> Ok(ApplicationCommand)
    3 -> Ok(MessageComponent)
    4 -> Ok(ApllicationCommandAutoComplete)
    5 -> Ok(ModalSubmit)
    _ -> Error(Nil)
  }
}

pub fn decode(dynamic: Dynamic) -> Result(InteractionType, DecodeErrors) {
  use ty <- result.try(int(from: dynamic))
  from_int(ty)
  |> result.map_error(fn(_) { [DecodeError("Int(1-5)", int.to_string(ty), [])] })
}
