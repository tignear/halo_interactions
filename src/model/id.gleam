import gleam/dynamic.{type DecodeErrors, type Dynamic}
import gleam/result
import model/snowflake.{type Snowflake}

pub opaque type Id(marker) {
  Id(snowflake: Snowflake)
}

pub type UserMarker

pub type MemberMarker

pub type RoleMarker

pub type GuildMarker

pub type ChannelMarker

pub type MessageMarker

pub type AttachmentMarker

pub type InteractionMarker

pub type ApplicationMarker

pub type UserId =
  Id(UserMarker)

pub type MemberId =
  Id(MemberMarker)

pub type RoleId =
  Id(RoleMarker)

pub type GuildId =
  Id(GuildMarker)

pub type ChannelId =
  Id(ChannelMarker)

pub type MessageId =
  Id(MessageMarker)

pub type AttachmentId =
  Id(AttachmentMarker)

pub type InteractionId =
  Id(InteractionMarker)

pub type ApplicationId =
  Id(ApplicationMarker)



pub fn unsafe_new(snowflake: Snowflake) -> Id(marker) {
  Id(snowflake)
}

pub fn unsafe_cast(id: Id(a)) -> Id(b) {
  id
  |> snowflake()
  |> unsafe_new()
}

pub fn member_id_to_user_id(id: MemberId) -> UserId {
  unsafe_cast(id)
}

pub fn snowflake(id: Id(marker)) -> Snowflake {
  id.snowflake
}

pub fn value(id: Id(marker)) -> Int {
  snowflake.value(id.snowflake)
}

pub fn decode(d: Dynamic) -> Result(Id(marker), DecodeErrors) {
  use v <- result.map(snowflake.decode(d))
  unsafe_new(v)
}
