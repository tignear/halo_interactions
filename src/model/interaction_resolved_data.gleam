import birl.{type Time}
import gleam/dict.{type Dict}
import gleam/dynamic.{
  type DecodeErrors, type Decoder, type Dynamic, bool, dict, field, int, list,
  optional_field, string,
}
import gleam/option.{type Option}
import model/attachment.{type Attachment}
import model/id.{
  type AttachmentId, type ChannelId, type MessageId, type RoleId, type UserId, type MemberId
}
import model/role.{type Role}
import model/thread_metadata.{type ThreadMetadata}
import model/user.{type User}
import model/util

// https://discord.com/developers/docs/interactions/receiving-and-responding#interaction-object-resolved-data-structure
pub type InteractionResolvedData {
  InteractionResolvedData(
    users: Dict(UserId, User),
    members: Dict(MemberId, PartialMember),
    roles: Dict(RoleId, Role),
    channels: Dict(ChannelId, PartialChannel),
    messages: Dict(MessageId, PartialMessage),
    attachments: Dict(AttachmentId, Attachment),
  )
}

pub type PartialMember {
  PartialMember(
    nick: Option(String),
    avatar: Option(String),
    roles: List(RoleId),
    joined_at: Time,
    premium_since: Option(Time),
    flags: Int,
    pending: Option(Bool),
    permissions: Int,
    communication_disabled_until: Option(Time),
  )
}

fn partial_member_decoder() -> Decoder(PartialMember) {
  dynamic.decode9(
    PartialMember,
    optional_field("nick", of: string),
    optional_field("avatar", of: string),
    field("roles", of: list(of: id.decode)),
    field("joined_at", of: util.decode_time),
    optional_field("premium_since", of: util.decode_time),
    field("flags", of: util.large_int_decoder()),
    optional_field("pending", of: bool),
    field("permissions", of: util.large_int_decoder()),
    optional_field("communication_disabled_until", of: util.decode_time),
  )
}

pub type PartialChannel {
  PartialChannel(
    id: ChannelId,
    name: Option(String),
    kind: Int,
    permissions: Int,
    thread_metadata: Option(ThreadMetadata),
    parent_id: Option(ChannelId),
  )
}

fn partial_channel_decoder() -> Decoder(PartialChannel) {
  dynamic.decode6(
    PartialChannel,
    field("id", id.decode),
    optional_field("name", string),
    field("kind", int),
    field("permissions", util.large_int_decoder()),
    optional_field("thread_metadata", thread_metadata.decode),
    optional_field("parent_id", id.decode),
  )
}

// TODO: 
pub type PartialMessage {
  PartialMessage(id: MessageId)
}

fn partial_message_decoder() -> Decoder(PartialMessage) {
  dynamic.decode1(PartialMessage, field("id", id.decode))
}

pub fn decode(d: Dynamic) -> Result(InteractionResolvedData, DecodeErrors) {
  dynamic.decode6(
    InteractionResolvedData,
    field("users", of: dict(of: id.decode, to: user.decoder())),
    field("members", of: dict(of: id.decode, to: partial_member_decoder())),
    field("roles", of: dict(of: id.decode, to: role.decode)),
    field("channels", of: dict(of: id.decode, to: partial_channel_decoder())),
    field("messages", of: dict(of: id.decode, to: partial_message_decoder())),
    field("attachments", of: dict(of: id.decode, to: attachment.decode)),
  )(d)
}
