import gleam/json.{type Json, int, null, nullable, object}
import gleam/option.{type Option}
import interaction/interaction_callback_type.{type InteractionCallbackType}

//https://discord.com/developers/docs/interactions/receiving-and-responding#responding-to-an-interaction
pub type InteractionResponse {
  InteractionResponse(kind: InteractionCallbackType, data: Option(Nil))
}

pub fn to_json(v: InteractionResponse) -> Json {
  object([
    #("type", int(interaction_callback_type.to_int(v.kind))),
    #("data", nullable(v.data, of: fn(_) { null() })),
  ])
}
