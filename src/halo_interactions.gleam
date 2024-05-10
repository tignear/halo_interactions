import gleam/bit_array
import gleam/erlang/process
import handler
import mist
import verifying
import wisp

pub fn main() {
  // This sets the logger to print INFO level logs, and other sensible defaults
  // for a web application.
  wisp.configure_logger()

  // Here we generate a secret key, but in a real application you would want to
  // load this from somewhere so that it is not regenerated on every restart.
  let secret_key_base = wisp.random_string(64)
  let assert Ok(public_key) =
    bit_array.base16_decode(
      "9f77a9488f81d243ae6d010789db870eab60f8f641f43348ceb1d6bbb751fd64",
    )
  let ctx =
    handler.Context(verifying: verifying.new_verifing_middleware(public_key))
  // Start the Mist web server.
  let assert Ok(_) =
    wisp.mist_handler(handler.handle(ctx, _), secret_key_base)
    |> mist.new
    |> mist.port(8000)
    |> mist.start_http

  // The web server runs in new Erlang process, so put this one to sleep while
  // it works concurrently.
  process.sleep_forever()
}
