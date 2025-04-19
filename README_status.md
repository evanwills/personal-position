# `see-me` Type & Sub-Type codes

* [About `see-me`](./README.md)
  * [Introduction](./README.md#introduction)
  * [Data retention](./README.md#data-retention)
  * [Making a connection](./README.md#making-a-connection)
  * [Sharing your location](./README.md#sharing-your-location)
  * [If you can't see me, I can't see you.](./README.md#if-you-cant-see-me-i-cant-see-you)
  * [Receiving other peoples location](./README.md#receiving-other-peoples-location)
  * [Encryption](./README.md#encryption)
* [Standard data](./README_data.md)
  * [Introduction](#introduction)
  * [Location, simple status, text request body](./README_data.md#location-simple-status-text-request-body)
  * [Location, simple status, text response body](./README_data.md#location-simple-status-text-response-body)
  * [Encrypted blob (`data`)](./README_data.md#encrypted-blob-data)
    * [blob `data` for location update](./README_data.md#blob-data-for-location-update)
    * [blob `data` for simple status update](./README_data.md#blob-data-for-simple-status-update)
    * [blob `data` for text message](./README_data.md#blob-data-for-text-message)
* Type & Sub-Type codes
  * [Primary data types](#primary-data-types)
  * [Simple status updates](#simple-status-updates)
    * [Danger personal status updates](#danger-personal-status-updates)
    * [General personal status updates](#general-personal-status-updates)
  * [Movement types](#movement-types)
  * [Text message types](#text-message-types)
  * [Connection management types](#connection-management-types)
  * [Server message types](#server-message-types)
* [Connection management](./README_connection.md)

## Primary data types

1. location update
2. location sharing state
3. simple status update
4. text message
5. Connection management
6. Server message

## Simple status updates

> __Note:__ Simple status updates will be seen regarless of the
>           `targetID`'s location settings

### Danger personal status updates:

0. "Location sharing turned off"
1. "Location sharing turned on"
2. "Notifications turned off"
3. "Notifications turned on"
4. "I'm lost"
5. "I feel unsafe"
6. "I need urgent help"
7. "SOS"

### General personal status updates

8. "I'm OK"
9. "Please call me"
10. "Please message me"
11. "What's your ETA"
12. "On my way home"
13. "I'll be home late"

## Movement types

1. Stationary (user's location is unchanged since last packet was sent)
2. Moving (mode unknown)
3. Walking
4. Cycling, skating etc
5. Driving / on bus/light rail
6. On train.

## Text message types

> __Note:__ Text messages will be seen regarless of the `targetID`'s
>           location settings

1. New message
2. Reply to message
3. Update past message
4. Delete message
5. Share location pin

## Connection management types

1. Initiate connection (source user wants to confirm "connection" with target user)
2. Confirm connection
3. Connection confirmed
4. Connection expired
5. Break connection (User no longer wants to be connected with other
   person (`targetID`))

## Server message types

1. Planned server mantenance
2. Planned server outage
3. Server is experiencing heavy load
4. Payment due
5. Automatic payment failed
6. Payment received.
7. Request token to add user to payment plan
8. Token to add user to payment plan
