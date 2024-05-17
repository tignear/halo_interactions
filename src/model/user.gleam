import gleam/dynamic.{type Decoder, field}
import model/id.{type UserId}
// TODO: 

pub type User {
  User(id: UserId)
}

pub fn decoder() -> Decoder(User) {
  dynamic.decode1(User, field("id", id.decode))
}
