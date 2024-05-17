import gleam/io
import gleam/json
import gleam/option.{Some}
import model/interaction_callback.{InteractionCallback}
import model/interaction_callback_data.{InteractionCallbackData}
import model/interaction_callback_type
import verifying.{type VerifyingMiddleWare}
import wisp.{type Request, type Response}

pub type Context {
  Context(verifying: VerifyingMiddleWare)
}

pub fn handle(ctx: Context, req: Request) -> Response {
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use body <- wisp.require_bit_array_body(req)
  use interaction <- ctx.verifying(body, req)
  InteractionCallback(
    interaction_callback_type.ChannelMessageWithSource,
    Some(
      InteractionCallbackData(
        ..interaction_callback_data.default(),
        content: "pong!",
      ),
    ),
  )
  |> interaction_callback.to_json
  |> json.to_string_builder
  |> wisp.json_response(200)
}
