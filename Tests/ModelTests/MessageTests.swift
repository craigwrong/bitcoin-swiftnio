import XCTest
@testable import Model
import Network

final class MessageTests: XCTestCase {

    func testIPv6() {
        let broadcast = IPv4Address.broadcast
        print(broadcast.rawValue.hex)
        let loopback = IPv4Address.loopback
        print(loopback.rawValue.hex)
        let loopback6 = IPv6Address.loopback
        print(loopback6.rawValue.hex)
        let fakeLoopback6 = IPv6Address(Data(repeating: 0, count: 15) + Data([1]))!
        print(fakeLoopback6.rawValue.hex)
        let mappedLoopback = IPv6Address(Data(repeating: 0, count: 10) + Data(repeating: 0xff, count: 2) + loopback.rawValue)!
        print(mappedLoopback.rawValue.hex)
    }

    func testVerackMessage() throws {
        let message = Message(network: .main, command: "verack", payload: .init())
        XCTAssert(message.isChecksumOk)
        guard let messageRoundTrip = Message(message.data) else {
            XCTFail(); return
        }
        XCTAssert(messageRoundTrip.isChecksumOk)
        XCTAssertEqual(message, messageRoundTrip)
        XCTAssertEqual(message.data, messageRoundTrip.data)
    }

    func testVersionMessage() throws {
        let receiverAddress = IPv6Address(Data(repeating: 0x00, count: 10) + Data(repeating: 0xff, count: 2) + IPv4Address.loopback.rawValue)!
        let version = Version(versionIdentifier: .latest, services: .all, receiverServices: .all, receiverAddress: receiverAddress, receiverPort: 18444, transmitterServices: .all, transmitterAddress: .init(Data(repeating: 0x00, count: 16))!, transmitterPort: 0, nonce: 0xF85379C9CB358012, userAgent: "/Satoshi:25.1.0/", startHeight: 916, relay: true)
        let message = Message(network: .regtest, command: "version", payload: version.data)
        XCTAssert(message.isChecksumOk)
        guard let messageRoundTrip = Message(message.data) else {
            XCTFail(); return
        }
        XCTAssert(messageRoundTrip.isChecksumOk)
        XCTAssertEqual(message, messageRoundTrip)
        XCTAssertEqual(message.data, messageRoundTrip.data)
    }

    func testVersion() throws {
        let receiverAddress = IPv6Address(Data(repeating: 0x00, count: 10) + Data(repeating: 0xff, count: 2) + IPv4Address.loopback.rawValue)!
        let version = Version(versionIdentifier: .latest, services: .all, receiverServices: .all, receiverAddress: receiverAddress, receiverPort: 18444, transmitterServices: .all, transmitterAddress: .init(Data(repeating: 0x00, count: 16))!, transmitterPort: 0, nonce: 0xF85379C9CB358012, userAgent: "/Satoshi:25.1.0/", startHeight: 916, relay: true)
        guard let versionRoundTrip = Version(version.data) else {
            XCTFail(); return
        }
        XCTAssertEqual(version, versionRoundTrip)
        XCTAssertEqual(version.data, versionRoundTrip.data)
    }
}
/*

00000000000000000000ffff7f000001
7f1101000900000000000000888f6c6500000000090000000000000000000000100000000040880300600040480c0900000000000000000000001000000000408803006000400000128035cbc97953f8102f5361746f7368693a32352e312e302fcf05050001

7f1101000900000000000000c78c6c6500000000090000000000000000000000100000000000770000600040480c0900000000000000000000001000000000007700006000400000128035cbc97953f8102f5361746f7368693a32352e312e302fcf05050001

7f110100
0900000000000000
d18b6c6500000000
0900000000000000
00000000100000005000f60300600040
480c
0900000000000000
00000000100000005000f60300600040
0000
128035cbc97953f8
10
2f5361746f7368693a32352e312e302f
cf050500
01

72110100 ........................... Protocol version: 70002
0100000000000000 ................... Services: NODE_NETWORK
bc8f5e5400000000 ................... [Epoch time][unix epoch time]: 1415483324

0100000000000000 ................... Receiving node's services
00000000000000000000ffffc61b6409 ... Receiving node's IPv6 address
208d ............................... Receiving node's port number

0100000000000000 ................... Transmitting node's services
00000000000000000000ffffcb0071c0 ... Transmitting node's IPv6 address
208d ............................... Transmitting node's port number

128035cbc97953f8 ................... Nonce

0f ................................. Bytes in user agent string: 15
2f5361746f7368693a302e392e332f ..... User agent: /Satoshi:0.9.3/

cf050500 ........................... Start height: 329167
01 ................................. Relay flag: true
*/
