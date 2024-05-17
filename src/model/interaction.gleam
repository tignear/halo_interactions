import gleam/dynamic.{field, optional_field}
import gleam/list
import gleam/option.{type Option}
import gleam/result
import model/id.{type ApplicationId, type InteractionId}
import model/interaction_data.{type InteractionData}
import model/interaction_type.{type InteractionType}
import model/util.{all_errors}

// https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-object
pub type Interaction {
  Interaction(
    id: InteractionId,
    application_id: ApplicationId,
    kind: InteractionType,
    data: Option(InteractionData),
  )
}

pub fn decode(d: dynamic.Dynamic) -> Result(Interaction, dynamic.DecodeErrors) {
  let id = field("id", of: id.decode)(d)
  let application_id = field("application_id", of: id.decode)(d)
  let kind = field("type", of: interaction_type.decode)(d)
  let kind_and_data = case kind {
    Ok(kind) ->
      result.map(
        optional_field("data", of: interaction_data.decoder(kind))(d),
        fn(data) { #(kind, data) },
      )
    Error(err) -> Error(err)
  }
  case id, application_id, kind_and_data {
    Ok(id), Ok(application_id), Ok(#(kind, data)) ->
      Ok(Interaction(
        id: id,
        application_id: application_id,
        kind: kind,
        data: data,
      ))
    id, application_id, kind_and_data ->
      Error(
        list.concat([
          all_errors(id),
          all_errors(application_id),
          all_errors(kind_and_data),
        ]),
      )
  }
}
