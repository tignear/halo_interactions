import gleam/dynamic.{type Decoder}
import gleam/result
import model/application_command_data.{type ApplicationCommandData}
import model/interaction_type.{type InteractionType}
import model/message_component_data.{
  type MessageComponentData, MessageComponentData,
}
import model/modal_submit_data.{type ModalSubmitData,ModalSubmitData}

pub type InteractionData {
  ApplicationCommand(ApplicationCommandData)
  MessageComponent(MessageComponentData)
  ModalSubmit(ModalSubmitData)
}

pub fn decoder(kind: InteractionType) -> Decoder(InteractionData) {
  case kind {
    interaction_type.Ping -> panic("unreachable")
    interaction_type.ApplicationCommand -> fn(x) {
      result.map(application_command_data.decode(x), ApplicationCommand)
    }
    interaction_type.ApllicationCommandAutoComplete -> fn(x) {
      result.map(application_command_data.decode(x), ApplicationCommand)
    }
    interaction_type.MessageComponent -> fn(_) {
      Ok(MessageComponent(MessageComponentData))
    }

    interaction_type.ModalSubmit -> fn(_) { Ok(ModalSubmit(ModalSubmitData)) }
  }
}
