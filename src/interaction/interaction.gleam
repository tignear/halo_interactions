import gleam/dynamic.{type Decoder, field, string}
import interaction/interaction_type.{type InteractionType}

// https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-object-interaction-type
pub type Interaction {
  Interaction(id: String, application_id: String, kind: InteractionType)
}

pub fn decoder() -> Decoder(Interaction) {
  dynamic.decode3(
    Interaction,
    field("id", of: string),
    field("application_id", of: string),
    field("type", of: interaction_type.decode),
  )
}
