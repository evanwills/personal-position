# personal-position

Personal location sharing app with a focus on privacy and security.

This app is intended for use by people who regularly share the same
physical space and want to share the location.
The target audience is families.

This app intends to make it as difficult as possible to be uses for
coercive control.

## Data retention

Data will only be stored on an intermediary server for a maximum of
7 days and will be deleted from the intermediary server as soon as
the recipient has confirmed that the packets have been received.

## Making a connection

To be able to see another person's location both people must make a
"connection" by showing each other a QR code from their screen. The
QR code contains the user's public key and their personal ID as
registered on the intermediary server. The two devices then create a
shared symetric key that they both store locally.

> __Note:__ To use multiple devices a separate connection must be
>           made with each device.

## Sharing your location

Your location is only shared directly with individuals you have
shared QR codes with (made a "connection" with). When your location
is sent to the intermediary server, a separate packet is sent for
each person you have a "connection" with.

Each packet has:

```json
{
    "srcID": "[40 character alpha-numeric string]",
    "targetID": "[40 character alpha-numeric string]",
    "packetID": "[number]",
    "data": "[encrypted blob]"
}
```

The encrypted data blob contains the following JSON
```JSON
{
    "start": "[ISO 8601 date/time format string]",
    "end": "[ISO 8601 date/time format string]",
    "lat": "[number]",
    "long": "[number]",
    "message": "[UTF8 string, base64 encoded] (512 char limit)",
    "sharing": true,
    "status": "[number] (16 bit)",
    "travelSpeed": "[number] (metres/second)"
}
```

### If you can't see me, I can't see you.

Each packet sent to a `targetID` contains your location sharing
status. The target person's app will stop sending you their location
until they allow it. This must be done each time your location is
disabled.

While your location is disabled you may still get personal status
updates if the target person has allowed it.

## Receiving other peoples location

The app sends a request to the server listing with an array

## Encryption

The `data` blob is first encrypted using the shared symetric key,
then with the public key of the other half of the "connection", then
again with your own private key.


