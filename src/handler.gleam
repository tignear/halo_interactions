import verifying.{type VerifyingMiddleWare}
import wisp.{type Request, type Response}

pub type Context {
  Context(verifying: VerifyingMiddleWare)
}

pub fn handle(ctx: Context, req: Request) -> Response {
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use body <- wisp.require_bit_array_body(req)
  use _interaction <- ctx.verifying(body, req)
  wisp.response(200)
}
