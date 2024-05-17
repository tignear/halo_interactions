import birl.{type Time}
import birl/duration.{type Duration}
import gleam/dynamic.{
  type DecodeErrors, type Dynamic, bool, field, int, optional_field,
}
import gleam/option.{type Option}
import gleam/result
import model/util

// https://discord.com/developers/docs/resources/channel#thread-metadata-object
pub type ThreadMetadata {
  ThreadMetadata(
    archived: Bool,
    auto_archive_duration: Duration,
    archive_timestamp: Time,
    locked: Bool,
    invitable: Option(Bool),
    create_timestamp: Option(Time),
  )
}

pub fn decode(d: Dynamic) -> Result(ThreadMetadata, DecodeErrors) {
  dynamic.decode6(
    ThreadMetadata,
    field("archived", of: bool),
    field("auto_archive_duration", of: fn(x) {
      result.map(int(x), duration.minutes)
    }),
    field("archive_timestamp", of: util.decode_time),
    field("locked", of: bool),
    optional_field("invitable", of: bool),
    optional_field("create_timestamp", of: util.decode_time),
  )(d)
}
