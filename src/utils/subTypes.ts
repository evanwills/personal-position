import {
  SPacketType,
  SSimpleStatusSubType,
  SMovementSubType,
  STextMsgSubType,
  SServerMsgSubType,
} from '../types/packets.d.ts';

export const packetType : {[key:number]:SPacketType} = {
  1: 'LOCATION_UPDATE',
  2: 'SHARING_STATE',
  3: 'SIMPLE_STATUS_UPDATE',
  4: 'TEXT_MESSAGE',
  5: 'CONNECTION_MANAGEMENT',
  6: 'SERVER_MESSAGE',
};

export const simpleStatusSubType : {[key:number]:SSimpleStatusSubType} = {
  1: 'SoS',
  2: 'I need urgent help',
  3: 'I feel unsafe',
  4: 'I\'m lost',

  10: 'Please call me',
  11: 'Please message me',
  12: 'What\'s your ETA?',

  20: 'I\'m OK',
  21: 'I\'m on my way home',
  22: 'I\'ll be home late',

  90: 'LOCATION OFF',
  91: 'LOCATION ON',
  92: 'NOTIFICATIONS OFF',
  93: 'NOTIFICATIONS ON',
};

export const movementSubType : {[key:number]:SMovementSubType} = {
  1: 'stationary',
  2: 'moving',
  3: 'walking',
  4: 'self-propelled',
  5: 'motor trainsport',
  6: 'train',
};

export const textMsgSubType : {[key:number]:STextMsgSubType} = {
  1: 'New message',
  2: 'Reply to message',
  3: 'Update past message',
  4: 'Delete message',
  5: 'Share location pin',
};

export const serverMsgSubType : {[key:number]:SServerMsgSubType} = {
  1: 'Planned server mantenance',
  2: 'Planned server outage',
  3: 'Server is experiencing heavy load',
  4: 'Payment due',
  5: 'Automatic payment failed',
  6: 'Payment received.',
  7: 'Request token to add user to payment plan',
  8: 'Token to add user to payment plan',
}
