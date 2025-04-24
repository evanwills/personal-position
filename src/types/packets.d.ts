type TLocationCoord = number;
type TServerHostName = string;
type TPublicKey = string;
type TConnectionID = string;
type THash = string;
type TPairID = string;


type SPacketType = 'LOCATION_UPDATE'|'SHARING_STATE'|'SIMPLE_STATUS_UPDATE'|'TEXT_MESSAGE'|'CONNECTION_MANAGEMENT'|'SERVER_MESSAGE';

type SSimpleStatusSubType = 'SoS'|'I need urgent help'|'I feel unsafe'|'I\'m lost'|'Please call me'|'Please message me'|'What\'s your ETA?'|'I\'m OK'|'I\'m on my way home'|'I\'ll be home late'|'LOCATION OFF'|'LOCATION ON'|'NOTIFICATIONS OFF'|'NOTIFICATIONS ON';

type SMovementSubType = 'stationary'|'moving'|'walking'|'self-propelled'|'motor trainsport'|'train';

type STextMsgSubType = 'New message'|'Reply to message'|'Update past message'|'Delete message'|'Share location pin';

type SServerMsgSubType = 'Planned server mantenance'|'Planned server outage'|'Server is experiencing heavy load'|'Payment due'|'Automatic payment failed'|'Payment received.'|'Request token to add user to payment plan'|'Token to add user to payment plan';

type TLocationPin = {
  longitude: TLocationCoord,
  latitude: TLocationCoord,
  radius: number,
}

type TLocationBlobPacket = {
  type: SPacketType,
  subType: SMovementSubType,
  longitude: TLocationCoord,
  latitude: TLocationCoord,
  speed: number,
  sentAt: Date,
};

type TSimpleStatusBlobPacket = {
  type: SPacketType,
  subType: [SSimpleStatusSubType],
  sentAt: Date,
};

type TTextMsgBlobPacket = {
  type: SPacketType,
  subType: TTextMsgSubType,
  parentPacketID: number,
  msgPart: number,
  totalParts: number,
  msg: string|TLocationPin,
};

type TServerMsgBlobPacket = {
  type: SPacketType,
  subType: SServerMsgSubType,
  host: TServerHostName,
  key: TPublicKey,
  expiresAt: Date,
  msg: string,
};

type TPacketData = {
  pairID: TPairID,
  packetID: number,
  data: TLocationBlobPacket|TSimpleStatusBlobPacket|TTextMsgBlobPacket|TServerMsgBlobPacket,
};

type TConnectionBlobPacket = {
  senderID: TConnectionID,
  recipientID: TConnectionID,
  signature: THash,
};
