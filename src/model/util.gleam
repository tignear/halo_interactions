import birl.{type Time}
import gleam/dynamic.{
  type DecodeError, type DecodeErrors, type Decoder, type Dynamic, DecodeError,
  any, int, string,
}
import gleam/int
import gleam/result

pub fn large_int_decoder() -> Decoder(Int) {
  any(of: [
    int,
    fn(x) {
      result.try(string(x), fn(x) {
        result.map_error(int.parse(x), fn(_) {
          [DecodeError(expected: "string represents int", found: x, path: [])]
        })
      })
    },
  ])
}

pub fn decode_time(d: Dynamic) -> Result(Time, DecodeErrors) {
  result.try(string(d), fn(d) {
    result.map_error(birl.parse(d), fn(_) {
      [DecodeError(expected: "string represents int", found: d, path: [])]
    })
  })
}

pub fn all_errors(result: Result(a, List(DecodeError))) -> List(DecodeError) {
  case result {
    Ok(_) -> []
    Error(errors) -> errors
  }
}
