import NIOCore
import Model

func handleIO(isClient: Bool = false, _ inbound: NIOAsyncChannelInboundStream<Message>, _ outbound: NIOAsyncChannelOutboundWriter<Message>) async throws -> () {

    var peerContext = PeerContext(isClient: isClient)

    if isClient {
        let message = getFirstMessage(context: &peerContext)
        try await outbound.write(message)
    }

    for try await message in inbound {
        if let response = try processMessage(message, context: &peerContext) {
            try await outbound.write(response)
        }
    }
}
