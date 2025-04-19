# `see-me` connection management

* [About `see-me`](./README.md)
  * [Introduction](./README.md#introduction)
  * [Data retention](./README.md#data-retention)
  * [Making a connection](./README.md#making-a-connection)
  * [Sharing your location](./README.md#sharing-your-location)
  * [If you can't see me, I can't see you.](./README.md#if-you-cant-see-me-i-cant-see-you)
  * [Receiving other peoples location](./README.md#receiving-other-peoples-location)
  * [Encryption](./README.md#encryption)
* [Standard data](./README_data.md)
  * [Introduction](./README_data.md#introduction)
  * [Location, simple status, text request body](./README_data.md#location-simple-status-text-request-body)
  * [Location, simple status, text response body](./README_data.md#location-simple-status-text-response-body)
  * [Encrypted blob (`data`)](./README_data.md#encrypted-blob-data)
    * [blob `data` for location update](./README_data.md#blob-data-for-location-update)
    * [blob `data` for simple status update](./README_data.md#blob-data-for-simple-status-update)
    * [blob `data` for text message](./README_data.md#blob-data-for-text-message)
* [Type & Sub-Type codes](./README_status.md)
  * [Primary data types](./README_status.md#primary-data-types)
  * [Simple status updates](./README_status.md#simple-status-updates)
    * [Danger personal status updates](./README_status.md#danger-personal-status-updates)
    * [General personal status updates](./README_status.md#general-personal-status-updates)
  * [Movement types](./README_status.md#movement-types)
  * [Text message types](./README_status.md#text-message-types)
  * [Connection management types](./README_status.md#connection-management-types)
  * [Server message types](./README_status.md#server-message-types)
* Connection management

---

To establish a connection between two clients:

1. `Client A` shows `Client B` a QR code containing a unique public
   key for `Client A` for that connection plus a unique identifier
   for `Client B` to use to address `Client A` for that connection.
2. `Client B` shows `Client A` a QR code containing a unique public
   key for `Client B` for that connection plus a unique identifier
   for `Client A` for that connection.
3. "Initiate connection"
   1. `Client A` creates an `initiate connection packet` and encrypts
      it using it's private key (matching the public key held by the
      server)
      ```JSON
      {
        "senderID": "Client A's pair ID",
        "recipientID": "Client B's pair ID",
      }
      ```
   2. `Client A` sends the encrypted `initiate connection packet` to
      the server.
   3. The server signs decrypts `initiate connection packet` using
      `Client A`'s user account public key to confirm it's
      authenticity
   4. The server creates a temporary record of the connection linking
      it to `Client A`'s user account
   5. The server signs the `initiate connection packet` and returns
      it to `Client A`
   6. `Client A` shares the signature with `Client B` via a QR code
4. Confirm connection
   1. `Client B` then sends a confirm connection packet to the server
      ```json
      {
        "senderID": "Client A's pair ID",
        "recipientID": "Client B's pair ID",
        // `signature` confirm that the server has already seen this
        // sender/recipient ID pair
        "signature": "[encrypted blob]"
      }
      ```
   2. The server uses the signature to verify the authenticity of
      the invite
   3. The server creates permanent connection between `Client A` and
      the `senderID` and another permanent connection between
      `Client B` and the `recipientID`
   4. The server sends a connection confirmed response.
