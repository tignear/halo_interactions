pub type InteractionCallbackType {
  Pong
  ChannelMessageWithSource
  DeferredChannelMessageWithSource
  DeferredUpdateMessage
  UpdateMessage
  ApplicationCommandAutocompleteResult
  Modal
  PremiumRequired
}

pub fn to_int(ty: InteractionCallbackType) -> Int {
  case ty {
    Pong -> 1
    ChannelMessageWithSource -> 4
    DeferredChannelMessageWithSource -> 5
    DeferredUpdateMessage -> 6
    UpdateMessage -> 7
    ApplicationCommandAutocompleteResult -> 8
    Modal -> 9
    PremiumRequired -> 10
  }
}
