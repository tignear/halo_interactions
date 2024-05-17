import gleam/json.{type Json, object}
// TODO: 


pub type AllowedMentions{
  AllowedMentions()
}
pub fn to_json(_d: AllowedMentions) -> Json {
  object([])
}