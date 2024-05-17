import ed25519/ed25519
import gleam/bit_array
import gleam/json
import gleam/list
import gleam/option.{None}
import gleam/result
import gleam/string
import model/interaction.{type Interaction}
import model/interaction_callback.{InteractionCallback}
import model/interaction_callback_type
import model/interaction_type
import wisp.{type Request, type Response}

type Handler =
  fn(Interaction) -> Response

pub type VerifyingMiddleWare =
  fn(BitArray, Request, Handler) -> Response

fn get_signature_header(req: Request, key: String) -> Result(BitArray, Nil) {
  let headers = req.headers
  use value <- result.try(list.key_find(headers, key))
  let r = bit_array.base16_decode(value)
  r
}

fn verify(
  body: BitArray,
  public_key: BitArray,
  req: Request,
) -> Result(Bool, Nil) {
  let headers = req.headers
  use signature <- result.try(get_signature_header(req, "x-signature-ed25519"))
  use timestamp <- result.try(list.key_find(headers, "x-signature-timestamp"))
  let message = bit_array.concat([bit_array.from_string(timestamp), body])
  use r <- ed25519.verify(message, signature, public_key)

  Ok(r)
}

fn verified(body: BitArray, handler: Handler) -> Response {
  case json.decode_bits(from: body, using: interaction.decode) {
    Ok(interaction) -> {
      case interaction.kind {
        interaction_type.Ping -> {
          let body =
            json.to_string_builder(
              interaction_callback.to_json(InteractionCallback(
                kind: interaction_callback_type.Pong,
                data: None,
              )),
            )
          wisp.response(200)
          |> wisp.json_body(body)
        }
        _ -> handler(interaction)
      }
    }
    Error(err) -> {
      wisp.log_error("decode error:" <> string.inspect(err))
      wisp.response(400)
    }
  }
}

pub fn new_verifing_middleware(key: BitArray) -> VerifyingMiddleWare {
  fn(body: BitArray, req: Request, handler: Handler) -> Response {
    case result.unwrap(verify(body, key, req), False) {
      True -> {
        verified(body, handler)
      }
      False -> {
        wisp.response(401)
      }
    }
  }
}
