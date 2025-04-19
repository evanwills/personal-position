# `see-me` standard data

* [About `see-me`](./README.md)
  * [Introduction](./README.md#introduction)
  * [Data retention](./README.md#data-retention)
  * [Making a connection](./README.md#making-a-connection)
  * [Sharing your location](./README.md#sharing-your-location)
  * [If you can't see me, I can't see you.](./README.md#if-you-cant-see-me-i-cant-see-you)
  * [Receiving other peoples location](./README.md#receiving-other-peoples-location)
  * [Encryption](./README.md#encryption)
* Standard data
  * [Introduction](#introduction)
  * [Location, simple status, text request body](#location-simple-status-text-request-body)
  * [Location, simple status, text response body](#location-simple-status-text-response-body)
  * [Encrypted blob (`data`)](#encrypted-blob-data)
    * [blob `data` for location update](#blob-data-for-location-update)
    * [blob `data` for simple status update](#blob-data-for-simple-status-update)
    * [blob `data` for text message](#blob-data-for-text-message)
* [Type & Sub-Type codes](./README_status.md)
  * [Primary data types](./README_status.md#primary-data-types)
  * [Simple status updates](./README_status.md#simple-status-updates)
    * [Danger personal status updates](./README_status.md#danger-personal-status-updates)
    * [General personal status updates](./README_status.md#general-personal-status-updates)
  * [Movement types](./README_status.md#movement-types)
  * [Text message types](./README_status.md#text-message-types)
  * [Connection management types](./README_status.md#connection-management-types)
  * [Server message types](./README_status.md#server-message-types)
* [Connection management](./README_connection.md)


## Introduction

Each connection will have two `pairID`s one pair for each direction
for the connection. The sender will use the recipient's `pairID` to
address packets to.


## Location, simple status, text request body

When a request is sent a list of the last packets received by the
client is sent back to the server so the server can immeditately
delete those packets.

```json
{
  "lastPacketsRecieved": [ //
    {
      // There will be two pairIDs are one for each direction of
      // cummunication
      "pairID": "sender's unique key for this pair",
      "packetIDs": []
    }
  ],
  "data": [
    {
      "pairID": "recipients' unique key for this pair",
      "packetID": 000010002,
      "blob": "Base64 encoded encrypted blob",
    }
  ]
}
```

## Location, simple status, text response body

```json
{
  // Confirmation that the server has deleted packets sent to
  // this client
  "syncMeta": [
    {
      "deletedPackets": null,
      "deliveredPackets": [],
      "pairID": "sender's unique key for this pair",
      "receivedPackets": [],
      "target": "sender"
    },
    {
      "deletedPackets": [],
      "deliveredPackets": null,
      "pairID": "recipient's unique key for this pair",
      "receivedPackets": null,
      "target": "recipient"
    }
  ],
  "data": [
    {
      "pairID": "recipient's unique key for this pair",
      "packetID": 000010002,
      // Blob is encrypted using the recipient's public key for this connection
      "blob": "Base64 encoded encrypted blob",
    },
    // Sometimes the server needs to communicate with a client
    // e.g. confirm that `Client B` has accepted a connection
    //      `Client C` as broken their connection
    //      `Server will be down for planned maintenance between
    //      X Date/time & Y Date/time
    // NOTE: Server messages are not encrypted
    {
      "pairID": "SERVER",
      "packetID": 000000079,
      "type": 5,
      "subType": 3,
      "data": {
        "serverHost": "see-me.com.au",
        "accountKey": "Account public key",
        "message": "Client B's pairID",
        "expiresAt": "2025-04-24T21:42:22+10:00",
      }
    }
  ]
}
```

## Encrypted blob (`data`)

### Outer blob

```JSON
// The outer blob is encrypted using the recipient's public key
{
  "senderID": "Sender's unique key for this pair",
  // The inner blob is encrypted using the sender's private key
  "blob": "Base64 encoded encrypted blob"
}
```

### Inner blob `data` for location update

Location packets can be sent up to 4 times a minute but will only be
sent while location is changing.

__Packet size:__ 45 characters

Structured form after parsing

```json
{ // This blob is encrypted using the sender's private key
  "type": 1,
  "subType": 3, // walking
  "sharing": 1, // 1 = true, 0 = false
  "long": "-033.86760393347335", // Longitude
  "lat": "+151.20859451303656", // Latitude
  "kmh": 000.0 // traveling speed in km/h
}
```

Compressed form during transmition and at rest on server

```text
131-033.86760393347335+151.20859451303656000.0
```


### Inner blob `data` for simple status update

Simple status update packets will only be sent when the client does
so manually.

__Packet size:__ 29 characters

Structured form after parsing

```json
{ // This blob is encrypted using the sender's private key
  "type": 3,
  "subType": 04,
  "sharing": 1, // 1 = true, 0 = false
  "sentAt": "2025-04-19T19:41:05+10:00"
}
```

Compressed form during transmition and at rest on server

```text
30412025-04-19T19:41:05+10:00
```

### Inner blob `data` for text message

Text message packets are always 124 characters long. The first 15
characters of the string are metadata the characters (ending in a
pipe/vertical bar `|`) are padding (if required) and the rest of
the packet is the text message.

__Packet size:__ 128 characters

Structured form after parsing

```json
{ // This blob is encrypted using the sender's private key
  "type": 4,
  "subType": 1,
  "sharing": 1, // 1 = true, 0 = false
  // The `parentPacketID` is the packet ID of the last message received
  // from the recipient or, if the message is a direct reply to
  // previous message, it refers to the packet ID of the message
  // being replied to.
  "parentPacketID": 000010632,
  // Because there can be collisions between packet IDs of sender and recipient this indicates whether this message should be attached to the  the parent
  // Sometimes when you're sending a text message, you want to reply
  // to yourself.
  "parentIsSender": 0, // 1 = true, 0 = false
  // If a message is longer than 113 characters `part` which part of
  // the whole message this packet is
  "part": 01,
  // If a message is longer than 113 characters this is the total
  // number of parts that make up the whole message
  "of": 01,
  // Padding ensures that text message packets are always 128
  // characters long. When padding is applied it's end is marked with
  // a pipe/vertical bar `|`
  "padding": "wpqLu96dgHIsWgRzizFmHX50NqPlNxP36L1fGBIn4IOjgU0kHhb8jxAhkE9J",
  // Text message within each packet can be up to 112 characters
  // long. Messages that are longer than 112 characters will be
  // split across multiple packets
  "msg": "Ok. We just came back from a walk on Mt Kosciuszko"
}
```

Compressed form during transmition and at rest on server

```text
41100001063200101wpqLu96dgHIsWgRzizFmHX50NqPlNxP36L1fGBIn4IOjgU0kHhb8jxAhkE9J|Ok. We just came back from a walk on Mt Kosciuszko
```
