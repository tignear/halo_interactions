import gleam/dynamic.{field, list, optional_field, string}
import gleam/option.{type Option}
import model/application_command_interaction_data_option.{
  type ApplicationCommandInteractionDataOption,
}
import model/id.{type GuildId, type Id, type InteractionId}
import model/interaction_resolved_data.{type InteractionResolvedData}

pub type InteractionTargetMarker

// https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-object-application-command-data-structure
pub type ApplicationCommandData {
  ApplicationCommandData(
    id: InteractionId,
    name: String,
    resolved: Option(InteractionResolvedData),
    options: Option(List(ApplicationCommandInteractionDataOption)),
    guild_id: Option(GuildId),
    target_id: Option(Id(InteractionTargetMarker)),
  )
}

pub fn decode(
  d: dynamic.Dynamic,
) -> Result(ApplicationCommandData, dynamic.DecodeErrors) {
  dynamic.decode6(
    ApplicationCommandData,
    field("id", of: id.decode),
    field("name", of: string),
    optional_field("resolved", of: interaction_resolved_data.decode),
    optional_field(
      "options",
      of: list(of: application_command_interaction_data_option.decode),
    ),
    optional_field("guild_id", of: id.decode),
    optional_field("target_id", of: id.decode),
  )(d)
}
