import { movementSubType, packetType, simpleStatusSubType } from './subTypes';

/**
 * Convert a coordinate value to an 18 character numeric string
 *
 * @param _whole  Whole matched string from regular expression
 * @param sign    sign part of string
 * @param int     integer part of string
 * @param decimal decimal part of string
 *
 * @returns coordinate value converted to an 18 character numeric
 *          string
 */
const coord2strInner = (
  _whole : string,
  sign : string,
  int : string,
  decimal : string,
) : string => {
  let output : string = (sign === '-')
    ? '0'
    : '1'
  output += int.padStart(3, '0');
  output += decimal.padEnd(14);

  return output;
}

/**
 * Convert a numeric long/lat geo-coordinate into encoded numeric
 * string value use when transmitting location data
 *
 * @param coord long/lat geo-coordinate number
 *
 * @returns
 */
const coord2str = (coord : TLocationCoord) : string => coord.toString().replace(/^(-)?([0-9]+)\.([0-9]+)$/, coord2strInner);

/**
 * Convert an encoded numeric string represeting a long/lat
 * geo-coordinate into a signed float
 *
 * @param str encoded numeric string represeting a long/lat
 *            geo-coordinate
 *
 * @returns number (float) represnting a long/lat geo-coordinate
 */
const str2coord = (str: string) : TLocationCoord => {
  if (/^[0-9]{18}$/.test(str) === true) {
    const multi = (str.substring(0, 1) === '0')
      ? -1
      : 1

    return parseFloat(`${str.substring(1,3)}.${str.substring(3)}`) * multi;
  }

  throw new Error('Could not parse location coordinate');
};

/**
 * Conver number traveling speed to encoded numeric string value use
 * when transmitting location data
 *
 * @param speed Traveling speed
 *
 * @returns four character numeric string
 */
const speed2Str = (speed: number) : string => {
  const tmp = Math.round(speed * 10) / 10;
  const output = tmp.toString().split('.');

  if (typeof output[1] === 'undefined') {
    output[1] = '0';
  }

  return `${output[0].padStart(3, '0')}${output[1]}`;
};

/**
 * Convert encoded four character numeric string representation of
 * traveling speed into float
 *
 * @param speed encoded four character numeric string
 *
 * @returns Number represeting traveling speed between 0 and 999.9
 */
export const str2speed = (speed: string) : number => parseFloat(
  `${speed.substring(0, 3)}.${speed.substring(3,1)}`,
);

/**
 * Convert location packet data into encoded numeric string
 *
 * @param data Location packet data object
 *
 * @returns Encode location packet numeric string
 */
export const locationData2str = (data: TLocationBlobPacket) : string => {
  let output = `${data.type}${data.subType}`

  output += Math.round(data.sentAt.getTime() / 1000).toString();

  output += coord2str(data.longitude);
  output += coord2str(data.latitude);
  output += speed2Str(data.speed);

  return output;
};

/**
 * Convert Encode location packet numeric string into object
 *
 * @param data Encode location packet numeric string
 *
 * @returns Location packet data object
 */
export const locationStr2data = (str: string) : TLocationBlobPacket => {
  if (/^[1-6][1-6][0-9]{50}$/.test(str) === false) {
    throw new Error('Could not parse location data');
  }

  return {
    type: parsePacketType(parseInt(str.substring(0, 1))),
    subType: parseMovementType(parseInt(str.substring(1, 1))),
    sentAt: new Date(parseInt(str.substring(2,13))),
    longitude: str2coord(str.substring(13, 31)),
    latitude: str2coord(str.substring(31, 49)),
    speed: parseFloat(str.substring(49)),
  };
};

export const parsePacketType = (input : string|number) : SPacketType => {
  const a = (typeof input === 'string')
    ? parseInt(input)
    : input;

  if (typeof packetType[a] === 'string') {
    return packetType[a] as SPacketType;
  }

  throw new Error('Could not determine packet type');
};

export const parseStatusType = (input : string|number) : SSimpleStatusSubType => {
  const a = (typeof input === 'string')
    ? parseInt(input)
    : input;

  if (typeof simpleStatusSubType[a] === 'string') {
    return simpleStatusSubType[a] as SSimpleStatusSubType;
  }

  throw new Error('Could not determine packet type');
};

export const parseMovementType = (input : number) : SMovementSubType => {
  const a = (typeof input === 'string')
    ? parseInt(input)
    : input;

  if (typeof movementSubType[a] === 'string') {
    return movementSubType[a] as SMovementSubType;
  }

  throw new Error('Could not determine movement type');
};

