import gleam/dynamic.{
  type DecodeErrors, type Dynamic, bool, field, int, optional_field, string,
}
import gleam/list
import gleam/option.{type Option}
import model/id.{type AttachmentId}
import model/util.{all_errors}

// https://discord.com/developers/docs/resources/channel#attachment-object
pub type Attachment {
  Attachment(
    id: AttachmentId,
    filename: String,
    description: Option(String),
    content_type: Option(String),
    size: Int,
    url: String,
    proxy_url: String,
    height: Option(Int),
    width: Option(Int),
    ephemeral: Option(Bool),
    duration_secs: Option(Int),
    waveform: Option(String),
    flags: Option(Int),
  )
}

pub fn decode(d: Dynamic) -> Result(Attachment, DecodeErrors) {
  let id = field("id", of: id.decode)(d)
  let filename = field("filename", of: string)(d)
  let description = optional_field("description", of: string)(d)
  let content_type = optional_field("content_type", of: string)(d)
  let size = field("size", of: int)(d)
  let url = field("url", of: string)(d)
  let proxy_url = field("proxy_url", of: string)(d)
  let height = optional_field("height", of: int)(d)
  let width = optional_field("width", of: int)(d)
  let ephemeral = optional_field("ephemeral", of: bool)(d)
  let duration_secs = optional_field("duration_secs", of: int)(d)
  let waveform = optional_field("waveform", of: string)(d)
  let flags = optional_field("waveform", of: int)(d)

  case
    id,
    filename,
    description,
    content_type,
    size,
    url,
    proxy_url,
    height,
    width,
    ephemeral,
    duration_secs,
    waveform,
    flags
  {
    Ok(id),
      Ok(filename),
      Ok(description),
      Ok(content_type),
      Ok(size),
      Ok(url),
      Ok(proxy_url),
      Ok(height),
      Ok(width),
      Ok(ephemeral),
      Ok(duration_secs),
      Ok(waveform),
      Ok(flags)
    ->
      Ok(Attachment(
        id: id,
        filename: filename,
        description: description,
        content_type: content_type,
        size: size,
        url: url,
        proxy_url: proxy_url,
        height: height,
        width: width,
        ephemeral: ephemeral,
        duration_secs: duration_secs,
        waveform: waveform,
        flags: flags,
      ))
    id,
      filename,
      description,
      content_type,
      size,
      url,
      proxy_url,
      height,
      width,
      ephemeral,
      duration_secs,
      waveform,
      flags ->
      Error(
        list.concat([
          all_errors(id),
          all_errors(filename),
          all_errors(description),
          all_errors(content_type),
          all_errors(size),
          all_errors(url),
          all_errors(proxy_url),
          all_errors(height),
          all_errors(width),
          all_errors(ephemeral),
          all_errors(duration_secs),
          all_errors(waveform),
          all_errors(flags),
        ]),
      )
  }
}
