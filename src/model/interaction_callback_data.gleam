import gleam/json.{type Json, array, bool, int, nullable, object, string}
import gleam/option.{type Option, None}
import model/allowed_mentions.{type AllowedMentions, AllowedMentions}
import model/component.{type Component}
import model/embed.{type Embed}
import model/poll.{type Poll}

pub type PartialAttachment {
  PartialAttachment(id: Int, description: String, filename: String)
}

pub type InteractionCallbackData {
  InteractionCallbackData(
    tts: Bool,
    content: String,
    embeds: List(Embed),
    allowed_mentions: AllowedMentions,
    flags: Int,
    components: List(Component),
    attachments: List(PartialAttachment),
    poll: Option(Poll),
  )
}

pub fn default() -> InteractionCallbackData {
  InteractionCallbackData(
    tts: False,
    content: "",
    embeds: [],
    allowed_mentions: AllowedMentions,
    flags: 0,
    components: [],
    attachments: [],
    poll: None,
  )
}

// TODO: 
pub fn partial_attachment_to_json(_d: PartialAttachment) -> Json {
  object([])
}

pub fn to_json(d: InteractionCallbackData) -> Json {
  object([
    #("tts", bool(d.tts)),
    #("content", string(d.content)),
    #("embeds", array(d.embeds, of: embed.to_json)),
    #("allowed_mentions", allowed_mentions.to_json(d.allowed_mentions)),
    #("flags", int(d.flags)),
    #("components", array(d.components, of: component.to_json)),
    #("attachments", array(d.attachments, of: partial_attachment_to_json)),
    #("poll", nullable(d.poll, of: poll.to_json)),
  ])
}
