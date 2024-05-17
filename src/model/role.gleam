import gleam/dynamic.{
  type DecodeErrors, type Dynamic, bool, field, int, optional_field, string,
}
import gleam/list
import gleam/option.{type Option}
import model/id.{type RoleId}
import model/role_tags.{type RoleTags, RoleTags}
import model/util.{all_errors}

// https://discord.com/developers/docs/topics/permissions#role-object
pub type Role {
  Role(
    id: RoleId,
    name: String,
    color: Int,
    hoist: Bool,
    icon: Option(String),
    unicode_emoji: Option(String),
    position: Int,
    permissions: Int,
    managed: Bool,
    mentionable: Bool,
    tags: RoleTags,
    flags: Int,
  )
}

pub fn decode(d: Dynamic) -> Result(Role, DecodeErrors) {
  let id = field("id", of: id.decode)(d)
  let name = field("name", of: string)(d)
  let color = field("color", of: int)(d)
  let hoist = field("hoist", of: bool)(d)
  let icon = optional_field("icon", of: string)(d)
  let unicode_emoji = optional_field("unicode_emoji", of: string)(d)
  let position = field("position", of: int)(d)
  let permissions = field("permissions", of: util.large_int_decoder())(d)
  let managed = field("managed", of: bool)(d)
  let mentionable = field("mentionable", of: bool)(d)
  let tags = Ok(RoleTags)
  let flags = field("permissions", of: util.large_int_decoder())(d)
  case
    id,
    name,
    color,
    hoist,
    icon,
    unicode_emoji,
    position,
    permissions,
    managed,
    mentionable,
    tags,
    flags
  {
    Ok(id),
      Ok(name),
      Ok(color),
      Ok(hoist),
      Ok(icon),
      Ok(unicode_emoji),
      Ok(position),
      Ok(permissions),
      Ok(managed),
      Ok(mentionable),
      Ok(tags),
      Ok(flags)
    ->
      Ok(Role(
        id: id,
        name: name,
        color: color,
        hoist: hoist,
        icon: icon,
        unicode_emoji: unicode_emoji,
        position: position,
        permissions: permissions,
        managed: managed,
        mentionable: mentionable,
        tags: tags,
        flags: flags,
      ))
    id,
      name,
      color,
      hoist,
      icon,
      unicode_emoji,
      position,
      permissions,
      managed,
      mentionable,
      tags,
      flags ->
      Error(
        list.concat([
          all_errors(id),
          all_errors(name),
          all_errors(color),
          all_errors(hoist),
          all_errors(icon),
          all_errors(unicode_emoji),
          all_errors(position),
          all_errors(permissions),
          all_errors(managed),
          all_errors(mentionable),
          all_errors(tags),
          all_errors(flags),
        ]),
      )
  }
}
