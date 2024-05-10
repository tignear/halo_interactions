import ed25519/ed25519
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn ed25519_test() {
  use key_pair <- ed25519.generate_key()
  let assert #(private_key, public_key) = key_pair
  let message = <<"Hello":utf8>>
  use signature <- ed25519.sign(message, public_key, private_key)
  use result <- ed25519.verify(message, signature, public_key)
  should.be_true(result)
}
