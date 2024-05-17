import gleam/json.{type Json, int, nullable, object}
import gleam/option.{type Option}
import model/interaction_callback_data.{type InteractionCallbackData}
import model/interaction_callback_type.{type InteractionCallbackType}

//https://discord.com/developers/docs/interactions/receiving-and-responding#responding-to-an-interaction
pub type InteractionCallback {
  InteractionCallback(
    kind: InteractionCallbackType,
    data: Option(InteractionCallbackData),
  )
}

pub fn to_json(v: InteractionCallback) -> Json {
  object([
    #("type", int(interaction_callback_type.to_int(v.kind))),
    #("data", nullable(v.data, of: interaction_callback_data.to_json)),
  ])
}
