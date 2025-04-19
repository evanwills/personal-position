# `see-me`

* About `see-me`
  * [Introduction](#introduction)
  * [Data retention](#data-retention)
  * [Making a connection](#making-a-connection)
  * [Sharing your location](#sharing-your-location)
  * [If you can't see me, I can't see you.](#if-you-cant-see-me-i-cant-see-you)
  * [Receiving other peoples location](#receiving-other-peoples-location)
  * [Encryption](#encryption)
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
* [Connection management](./README_connection.md)

## Introduction

`see-me` is primarily a location sharing app with a focus on privacy and security.

This app is intended to be used by people who regularly share the same
physical space and want to share their location with each other.

The target audience is families with teenage kids or where one or
more family members have a disability that means they may not be able
to communicate their location when they need assistance.

This app intends to make it as difficult as possible to be uses for
coercive control. This is achieved by the app only showing other
people's location while your location is visible to them.
i.e. If you turn off your device's location you cannot see anyone
else's location while other people cannot see your location.

Data is encrypted end-to-end using public/private key crypto. Key's
are shared by one device's screen showing a QR code and the other
device reading the QR Code. Public keys are never sent across the
network. Before data leaves a device it is encrypted using the
sender's private key then again using the recipient's public key.
The server only know's the recipient's ID and that the sender is
allowed to send data to the recipient.

> __Note:__ Each pair connection has unique public/private keys for
>           both sender and recipient and keys should be regenerated
>           every three months.

## Data retention

Data will only be stored on an intermediary server for a maximum of
7 days and will be deleted from the intermediary server as soon as
the recipient has confirmed that the packets have been received.

## Making a connection

To be able to see another person's location both people must make a
"connection" by showing each other a QR code from their screen.

> __Note:__ To use multiple devices a separate connection must be
>           made with each device.

(See [Connection management](./README_connection.md) for more info)

## Sharing your location

Your location is only shared directly with individuals you have
shared QR codes with (made a "connection" with). When your location
is sent to the intermediary server, a separate packet is sent for
each person you have a "connection" with.

See [Location, simple status, text request body](./README_data.md#location-simple-status-text-request-body)
for more info on data structures.


### If you can't see me, I can't see you.

Each packet sent to a `pairID` contains your location sharing
status. If you turn off your location, the target person's app will
stop sending you their location until they allow it. Your client will
also delete any new location data packets it receives after you turn
off your location.

While your location is disabled you may still get personal status
updates if the target person has allowed it.

## Receiving other peoples location

The app sends a request to the server listing with an array

## Encryption

The `data` blob is first encrypted using your private key,
then with the public key of the other half of the "connection".


