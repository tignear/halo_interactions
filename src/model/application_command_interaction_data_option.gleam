import gleam/dynamic.{
  type DecodeErrors, type Decoder, type Dynamic, DecodeError, bool, field, float,
  list, optional_field, string,
}
import gleam/list
import gleam/option.{type Option}
import gleam/result
import model/application_command_option_type.{type ApplicationCommandOptionType}
import model/id
import model/util.{all_errors}

pub type MentionableMarker

pub type ApplicationCommandOptionValue {
  StringValue(value: String)
  IntegerValue(value: Int)
  DoubleValue(value: Float)
  BooleanValue(value: Bool)
  UserIdValue(value: id.UserId)
  ChannelIdValue(value: id.ChannelId)
  RoleIdValue(value: id.RoleId)
  MentionableIdValue(value: id.Id(MentionableMarker))
  AttachmentIdValue(value: id.AttachmentId)
}

pub fn decode_option_value_string(
  d: Dynamic,
) -> Result(ApplicationCommandOptionValue, DecodeErrors) {
  use d <- result.map(string(d))
  StringValue(d)
}

pub fn decode_option_value_integer(
  d: Dynamic,
) -> Result(ApplicationCommandOptionValue, DecodeErrors) {
  use d <- result.map(util.large_int_decoder()(d))
  IntegerValue(d)
}

pub fn decode_option_value_double(
  d: Dynamic,
) -> Result(ApplicationCommandOptionValue, DecodeErrors) {
  use d <- result.map(float(d))
  DoubleValue(d)
}

pub fn decode_option_value_boolean(
  d: Dynamic,
) -> Result(ApplicationCommandOptionValue, DecodeErrors) {
  use d <- result.map(bool(d))
  BooleanValue(d)
}

pub fn decode_option_value_never(
  _d: Dynamic,
) -> Result(ApplicationCommandOptionValue, DecodeErrors) {
  Error([DecodeError(expected: "unreachable", found: "reached", path: [])])
}

pub fn decode_option_value_id_decoder(
  constructor: fn(id.Id(marker)) -> ApplicationCommandOptionValue,
) -> Decoder(ApplicationCommandOptionValue) {
  fn(d) {
    use d <- result.map(id.decode(d))
    constructor(d)
  }
}

// https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-object-application-command-interaction-data-option-structure
pub type ApplicationCommandInteractionDataOption {
  ApplicationCommandInteractionDataOption(
    name: String,
    kind: ApplicationCommandOptionType,
    value: Option(ApplicationCommandOptionValue),
    options: Option(List(ApplicationCommandInteractionDataOption)),
    focused: Option(Bool),
  )
}

pub fn decode(
  d: Dynamic,
) -> Result(ApplicationCommandInteractionDataOption, DecodeErrors) {
  let name = field("name", string)(d)
  let kind = field("type", application_command_option_type.decode)(d)
  let options = optional_field("options", list(decode))(d)
  let focused = optional_field("focused", bool)(d)
  use value_ty <- result.try(case kind {
    Ok(application_command_option_type.String) ->
      Ok(#(decode_option_value_string, application_command_option_type.String))
    Ok(application_command_option_type.Integer) ->
      Ok(#(decode_option_value_integer, application_command_option_type.Integer))
    Ok(application_command_option_type.Boolean) ->
      Ok(#(decode_option_value_boolean, application_command_option_type.Boolean))
    Ok(application_command_option_type.User) ->
      Ok(#(
        decode_option_value_id_decoder(UserIdValue),
        application_command_option_type.User,
      ))
    Ok(application_command_option_type.Channel) ->
      Ok(#(
        decode_option_value_id_decoder(ChannelIdValue),
        application_command_option_type.Channel,
      ))
    Ok(application_command_option_type.Role) ->
      Ok(#(
        decode_option_value_id_decoder(RoleIdValue),
        application_command_option_type.Role,
      ))
    Ok(application_command_option_type.Mentionable) ->
      Ok(#(
        decode_option_value_id_decoder(MentionableIdValue),
        application_command_option_type.Mentionable,
      ))
    Ok(application_command_option_type.Number) ->
      Ok(#(decode_option_value_double, application_command_option_type.Number))
    Ok(application_command_option_type.Attachment) ->
      Ok(#(
        decode_option_value_id_decoder(AttachmentIdValue),
        application_command_option_type.Attachment,
      ))
    Ok(kind) -> Ok(#(decode_option_value_never, kind))
    kind ->
      Error(
        list.concat([
          all_errors(name),
          all_errors(kind),
          all_errors(options),
          all_errors(focused),
        ]),
      )
  })
  let #(decoder, kind) = value_ty
  let value = optional_field("value", decoder)(d)
  case name, options, focused, value {
    Ok(name), Ok(options), Ok(focused), Ok(value) ->
      Ok(ApplicationCommandInteractionDataOption(
        name: name,
        kind: kind,
        options: options,
        value: value,
        focused: focused,
      ))
    name, options, focused, value ->
      Error(
        list.concat([
          all_errors(name),
          all_errors(options),
          all_errors(focused),
          all_errors(value),
        ]),
      )
  }
}
