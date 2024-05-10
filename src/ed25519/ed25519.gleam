@external(erlang, "ed25519_ffi", "verify")
pub fn verify(
  message: BitArray,
  signature: BitArray,
  public_key: BitArray,
  callback: fn(Bool) -> v,
) -> v

@external(erlang, "ed25519_ffi", "sign")
pub fn sign(
  message: BitArray,
  public_key: BitArray,
  private_key: BitArray,
  callback: fn(BitArray) -> v,
) -> v

// PrivateKey,PublicKey
@external(erlang, "ed25519_ffi", "generate_key")
pub fn generate_key(callback: fn(#(BitArray, BitArray)) -> v) -> v
