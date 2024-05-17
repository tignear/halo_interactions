import gleam/dynamic.{type DecodeErrors, type Dynamic, DecodeError, string}
import gleam/int
import gleam/result
// https://discord.com/developers/docs/reference#snowflakes
pub opaque type Snowflake {
  Snowflake(inner: Int)
}

pub fn from(value: Int) -> Result(Snowflake, Nil) {
  //TODO: reject invalid snowflake
  Ok(Snowflake(value))
}

pub fn value(snowflake: Snowflake) -> Int{
  snowflake.inner
}

pub fn decode(d: Dynamic) -> Result(Snowflake, DecodeErrors) {
  use d <- result.try(string(d))

  use u <- result.try(
    int.parse(d)
    |> result.map_error(fn(_) {
      [DecodeError(expected: "string represents snowflake", found: d, path: [])]
    }),
  )
  from(u)
  |> result.map_error(fn(_) {
    [DecodeError(expected: "snowflake", found: d, path: [])]
  })
}
// TODO: add utility methods
