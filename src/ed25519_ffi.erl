-module(ed25519_ffi).
-export([verify/4, sign/4, generate_key/1]).

verify(Message, Signature, Key,Callback) ->
    Callback(public_key:verify(Message, none, Signature, {ed_pub, ed25519, Key})).

sign(Message, PublicKey, PrivateKey,Callback) ->
    Callback(public_key:sign(Message, none, {ed_pri, ed25519, PublicKey, PrivateKey})).

generate_key(Callback) ->
    {'ECPrivateKey', 1, PrivateKey, _, PublicKey, asn1_NOVALUE} = public_key:generate_key(
        {namedCurve, ed25519}
    ),
    Callback({PrivateKey, PublicKey}).