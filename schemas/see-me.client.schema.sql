DROP TABLE IF EXISTS `packet_queue`;
DROP TABLE IF EXISTS `connection_locations`;
DROP TABLE IF EXISTS `connection_status_updates`;
DROP TABLE IF EXISTS `connection_text_messages`;
DROP TABLE IF EXISTS `self_location`;
DROP TABLE IF EXISTS `settings`;
DROP TABLE IF EXISTS `connections`;
DROP TABLE IF EXISTS `server_accounts`;
DROP TABLE IF EXISTS `location_pins`;
DROP TABLE IF EXISTS `server_accounts`;
DROP TABLE IF EXISTS `server_list`;
DROP TABLE IF EXISTS `enum_movement_types`;
DROP TABLE IF EXISTS `enum_simple_status_updatess`;
DROP TABLE IF EXISTS `enum_message_modes`;
DROP TABLE IF EXISTS `enum_movement_types`;

-- ===================================================================
-- START: enum tables

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- START: movement type values

CREATE TABLE `enum_movement_types` {
  `movement_type_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `movement_type_label` varchar(16) NOT NULL,
  `movement_type_description` varchar(96) NOT NULL,
	PRIMARY KEY (`movement_type_id`),
	UNIQUE KEY `UNI_movement_type_label` (`movement_type_label`)
}

INSERT INTO `enum_movement_types` VALUES
  ( 1, 'stationary', 'Person is not moving (or their device has not moved in the last 5 minutes)' ),
  ( 2, 'moving', 'Person is moving but we can not determine their mode of movement' ),
  ( 3, 'walking', 'Person is walking' ),
  ( 4, 'self powered', 'Person is cycling, skooting, skating or swimming' ),
  ( 5, 'driving', 'Person is a moving vehicle on a road' ),
  ( 6, 'on train', 'Person is a train or tram/light rail' );

--  END:  movement type values
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- START: simple status updates values

CREATE TABLE `enum_simple_status_updatess` {
  `simple_status_updates_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `simple_status_updates_label` varchar(16) NOT NULL,
  `simple_status_updates_description` varchar(96) NOT NULL,
	PRIMARY KEY (`simple_status_updates_id`),
	UNIQUE KEY `UNI_simple_status_updates_label` (`simple_status_updates_label`)
}

INSERT INTO `enum_simple_status_updatess` VALUES
  ( 0, 'location off', "Device's Location sharing turned off" ),
  ( 1, 'location on', "Device's Location sharing turned back on again" ),
  ( 2, "I'm lost", 'Person is lost and in distress' ),
  ( 3, 'I feel unsafe', 'Person is concerned for their personal safety' ),
  ( 4, 'I need urgent help', 'Something is wrong. Please come and help (or send help)' ),
  ( 5, 'SOS', 'Something is VERY wrong' ),
  ( 6, "I'm OK", '' );
  ( 7, 'Please call me', '' );
  ( 8, 'Please message me', '' );
  ( 9, "What's your ETA", '' );
  ( 10, 'On my way home', '' );
  ( 11, "I'll be home late", '' );

--  END:  simple status updates values
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- START: message mode values

CREATE TABLE `enum_message_modes` {
  `message_mode_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `message_mode_label` varchar(12) NOT NULL,
	PRIMARY KEY (`message_mode_id`),
	UNIQUE KEY `UNI_message_mode_label` (`message_mode_label`)
}

INSERT INTO `enum_message_modes` VALUES
  ( 1, 'new', 'New message' ),
  ( 2, 'reply', 'Reply to message' ),
  ( 3, 'update', 'Update past message' ),
  ( 4, 'delete', 'Delete message' ),
  ( 5, 'pin', 'Share location pin' );

--  END:  message mode values
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- START: Connection management type values

CREATE TABLE `enum_connection_management_types` {
  `manage_type_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `manage_type_label` varchar(12) NOT NULL,
  `manage_type_description` varchar(12) NOT NULL,
	PRIMARY KEY (`manage_type_id`),
	UNIQUE KEY `UNI_manage_type_label` (`manage_type_label`)
}

INSERT INTO `enum_connection_management_types` VALUES
  ( 1, 'init', 'Initiate connection (source user wants to confirm "connection" with target user)' ),
  ( 2, 'accept', 'Confirm connection' ),
  ( 3, 'confirmed', 'Connection initiator is told that connection has been confirmed' ),
  ( 4, 'expired', 'Connection request expired' ),
  ( 5, 'break', 'Break connection (User no longer wants to be connected with other person)' );

--  END:  Connection management type values
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- START: Server message type values

CREATE TABLE `enum_server_message_types` {
  `server_msg_type_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `server_msg_type_label` varchar(12) NOT NULL,
	PRIMARY KEY (`server_msg_type_id`),
	UNIQUE KEY `UNI_server_msg_type_label` (`server_msg_type_label`)
}

INSERT INTO `enum_server_message_types` VALUES
  ( 1, 'Planned server mantenance' ),
  ( 2, 'Planned server outage' ),
  ( 3, 'Server is experiencing heavy load' ),
  ( 4, 'Payment due' ),
  ( 5, 'Automatic payment failed' ),
  ( 6, 'Payment received' ),
  ( 7, 'Request token to add user to payment plan' ),
  ( 8, 'Token to add user to payment plan' );

--  END:  Server message type values
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

--  END:  enum tables
-- ===================================================================
-- START: data tables

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- START: Settings

CREATE TABLE `settings` {
  -- Locations are areas of interest that this client wants to be notified
  -- about when one of their connections enters or exits.
  `setting_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `setting_updated_at` timestamp NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  `setting_key` varchar(20) NOT NULL,
  `setting_name` varchar(20) NOT NULL,
  `setting_value_type` char(20) NOT NULL,
  `setting_value_default` varchar(128) NOT NULL,
  `setting_value` varchar(128) NOT NULL,
	PRIMARY KEY (`setting_id`),
	UNIQUE KEY `UNI_setting_key` (`setting_key`),
	UNIQUE KEY `UNI_setting_name` (`setting_name`)
};

INSERT INTO `settings` VALUES
  ( 1, CURRENT_TIMESTAMP, 'defaultServer', 'Default account', 'tinyint(3)', '1', '1' ),
  ( 2, CURRENT_TIMESTAMP, 'defaultAccount', 'Default account', 'tinyint(3)', '1', '1' ),
  ( 3, CURRENT_TIMESTAMP, 'username', "Public user name", 'varchar(64)', '', '' ),
  ( 4, CURRENT_TIMESTAMP, 'defaultLocationAge', "Default location age", 'mediumint(9)', '2592000', '2592000' ), -- one month
  ( 5, CURRENT_TIMESTAMP, 'defaultMessageAge', "Default message age", 'mediumint(9)', '15552000', '15552000' ), -- six months
  ( 6, CURRENT_TIMESTAMP, 'selfLocationAge', "Maximum length of time to store self locations", 'mediumint(9)', '15552000', '15552000' ), -- six months
  ( 7, CURRENT_TIMESTAMP, 'rekeyBefore', "Number of seconds after a key was created that it should be regenerated", 'mediumint(9)', '7776000', '7776000' ), -- ninty days
  ( 8, CURRENT_TIMESTAMP, 'rekeyWindow', "Number of seconds before key expires user should be notified they should rekey", 'mediumint(9)', '1209600', '1209600' ), -- two weeks

--  END:  Settings
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- START: Server list

CREATE TABLE `server_list` {
  `server_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `server_url` varchar(255) NOT NULL,
  `server_name` varchar(255) NOT NULL,
	PRIMARY KEY (`server_id`),
};

--  END:  Server list
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- START: Server accounts

CREATE TABLE `server_accounts` {
  `account_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `account_server_id` tinyint(3) unsigned NOT NULL,
  `account_key` varchar(255) NOT NULL,
  `account_session_key` varchar(255) DEFAULT NULL,
  `account_session_expires` timestamp DEFAULT NULL,
  `account_name` varchar(64) NOT NULL,
  `account_next_payment_date` timestamp DEFAULT NULL,
	PRIMARY KEY (`account_id`),
	UNIQUE KEY `UNI_account_name` (`account_name`),
  KEY `IND_account_session_expires` (`account_session_expires`),
	CONSTRAINT `foreign_connection_id_account_id`
		FOREIGN KEY (`account_server_id`)
		REFERENCES `server_list` (`server_id`)
};

--  END:  Server accounts
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- START: Location pins

CREATE TABLE `location_pins` {
  -- Locations are areas of interest that this client wants to be notified
  -- about when one of their connections enters or exits.
  `location_pin_id` smallint(3) unsigned NOT NULL AUTO_INCREMENT,
  `location_pin_longitude` char(20) NOT NULL,
  `location_pin_latitude` char(20) NOT NULL,
  `location_pin_radius` smallint(6) unsigned NOT NULL DEFAULT 100,
  `location_pin_name` varchar(64) NOT NULL,
  `location_pin_notify` tinyint(1) unsigned NOT NULL DEFAULT 0,
	PRIMARY KEY (`location_pin_id`),
	UNIQUE KEY `UNI_location_pin_name` (`location_pin_name`),
  KEY `IND_location_pin_notify` (`location_pin_notify`)
};

--  END:  Location pins
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- START: Connections

CREATE TABLE `connections` {
  `connection_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `connection_account_id` tinyint(3) unsigned NOT NULL,
  `connection_created_at` timestamp NOT NULL DEFAULT NOW(),
  `connection_packet_counter` int(11) unsigned NOT NULL DEFAULT 0, -- incremented every time a packet is sent to the recipient ID (up to four times a minute)
  `connection_rekey_after` timestamp NOT NULL, -- recommended time to rekey connection
  `connection_key_expires` timestamp NOT NULL, -- time after which keys will be deemed to have expired
  `connection_sender_id` char(40) NOT NULL,
  `connection_sender_key` char(255) NOT NULL,
  `connection_recipient_id` char(40) NOT NULL,
  `connection_recipient_key` char(255) NOT NULL, -- public key to encrypt packet data
  `connection_recipient_name` varchar(64) NOT NULL, -- Local name for other user in connection
  `connection_blocked` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `connection_location_age` mediumint(9) unsigned NOT NULL, -- How long to keep location data for this connection
  `connection_message_age` mediumint(9) unsigned NOT NULL, -- How long to keep message data for this connection
  `connection_recipient_avatar` blob DEFAULT NULL,
  `connection_recipient_current_longitude` char(20) DEFAULT NULL,
  `connection_recipient_current_latitude` char(20) DEFAULT NULL,
  `connection_recipient_current_location_pin_id` smallint(3) unsigned DEFAULT NULL,
  `connection_recipient_current_sharing` tinyint(1) unsigned NOT NULL DEFAULT 1,
  `connection_recipient_status_update` tinyint(3) unsigned DEFAULT NULL,
	PRIMARY KEY (`connection_id`),
	UNIQUE KEY `UNI_connection_sender_id` (`connection_sender_id`),
	UNIQUE KEY `UNI_connection_recipient_id` (`connection_recipient_id`),
	UNIQUE KEY `UNI_connection_recipient_name` (`connection_recipient_name`),
  KEY `IND_connection_blocked` (`connection_blocked`),
  KEY `IND_connection_location_age` (`connection_location_age`),
  KEY `IND_connection_message_age` (`connection_message_age`),
  KEY `IND_connection_recipient_current_location_pin_id` (`connection_recipient_current_location_pin_id`),
  KEY `IND_connection_rekey_after` (`connection_rekey_after`),
  KEY `IND_connection_key_expires` (`connection_key_expires`),
	CONSTRAINT `foreign_connection_account_id`
		FOREIGN KEY (`connection_account_id`)
		REFERENCES `server_accounts` (`account_id`),
	CONSTRAINT `foreign_connection_recipient_current_location_pin_id`
		FOREIGN KEY (`connection_recipient_current_location_pin_id`)
		REFERENCES `location_pins` (`location_pin_id`)
};

--  END:  Connections
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- START: Settings

CREATE TABLE `settings` {
  -- Locations are areas of interest that this client wants to be notified
  -- about when one of their connections enters or exits.
  `setting_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `setting_updated_at` timestamp NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  `setting_key` varchar(20) NOT NULL,
  `setting_name` varchar(20) NOT NULL,
  `setting_value_type` char(20) NOT NULL,
  `setting_value_default` varchar(128) NOT NULL,
  `setting_value` varchar(128) NOT NULL,
	PRIMARY KEY (`setting_id`),
	UNIQUE KEY `UNI_setting_key` (`setting_key`),
	UNIQUE KEY `UNI_setting_name` (`setting_name`)
};

INSERT INTO `settings` VALUES
  ( 1, CURRENT_TIMESTAMP, 'defaultServer', 'Default account', 'tinyint(3)', 1, 1 ),
  ( 2, CURRENT_TIMESTAMP, 'defaultAccount', 'Default account', 'tinyint(3)', 1, 1 ),
  ( 3, CURRENT_TIMESTAMP, 'username', "User's name", 'tinyint(3)', 1, 1 ),
  ( 4, CURRENT_TIMESTAMP, 'defaultLocationAge', "Default location age", 'mediumint(9)', 2592000, 2592000 ), -- one month
  ( 5, CURRENT_TIMESTAMP, 'defaultMessageAge', "Default message age", 'mediumint(9)', 15552000, 15552000 ), -- six months
  ( 5, CURRENT_TIMESTAMP, 'selfLocationAge', "Maximum length of time to store self locations", 'mediumint(9)', 15552000, 15552000 ), -- six months

--  END:  Settings
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- START: Self location

CREATE TABLE `self_location` {
  `self_locale_timestamp` timestamp NOT NULL DEFAULT NOW(),
  `self_locale_longitude` char(20) NOT NULL,
  `self_locale_latitude` char(20) NOT NULL,
  `self_locale_movement_type_id` tinyint(3) unsigned NOT NULL,
  `self_locale_location_pin_id` smallint(3) unsigned DEFAULT NULL,
  `self_locale_travel_speed` smallint(3) unsigned DEFAULT NULL,
	PRIMARY KEY (`self_locale_timestamp`),
  KEY `IND_self_locale_movement_type_id` (`self_locale_movement_type_id`),
  KEY `IND_self_locale_location_pin_id` (`self_locale_location_pin_id`),
	CONSTRAINT `foreign_self_locale_movement_type_id`
		FOREIGN KEY (`self_locale_movement_type_id`)
		REFERENCES `enum_movement_types` (`movement_type_id`),
	CONSTRAINT `foreign_self_locale_location_pin_id`
		FOREIGN KEY (`self_locale_location_pin_id`)
		REFERENCES `location_pins` (`location_pin_id`)
};

--  END:  Self location
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- START: Connection location

CREATE TABLE `connection_locations` {
  `connection_locations_connection_id` tinyint(3) unsigned NOT NULL,
  `connection_locations_packet_id` int(11) unsigned NOT NULL,
  `connection_locations_received_at` timestamp NOT NULL DEFAULT NOW(),
  `connection_locations_movement_type_id` tinyint(3) unsigned NOT NULL,
  `connection_locations_longitude` char(20) NOT NULL,
  `connection_locations_latitude` char(20) NOT NULL,
  `connection_locations_travel_speed` smallint(3) unsigned DEFAULT NULL,
  `connection_locations_self_locale_location_pin_id` smallint(3) unsigned DEFAULT NULL,
	PRIMARY KEY (`connection_locations_connection_id`),
  KEY `IND_connection_locations_connection_id` (`connection_locations_connection_id`),
  KEY `IND_connection_locations_movement_type_id` (`connection_locations_movement_type_id`),
  KEY `IND_connection_locations_self_locale_location_pin_id` (`connection_locations_self_locale_location_pin_id`),
  KEY `IND_connection_locations_received_at` (`connection_locations_received_at`),
	CONSTRAINT `foreign_connection_locations_connection_id`
		FOREIGN KEY (`connection_locations_connection_id`)
		REFERENCES `connections` (`connection_id`),
	CONSTRAINT `foreign_connection_locations_movement_type_id`
		FOREIGN KEY (`connection_locations_movement_type_id`)
		REFERENCES `enum_movement_types` (`movement_type_id`),
	CONSTRAINT `foreign_connection_locations_location_pin_id`
		FOREIGN KEY (`connection_locations_location_pin_id`)
		REFERENCES `location_pins` (`location_pin_id`)
};

--  END:  Connection location
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- START: Connection status updates

CREATE TABLE `connection_status_updates` {
  `connection_status_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `connection_status_connection_id` tinyint(3) unsigned NOT NULL,
  `connection_status_from_sender` tinyint(1) unsigned NOT NULL,
  `connection_status_type_id` tinyint(3) unsigned NOT NULL,
  `connection_status_packet_id` int(11) unsigned NOT NULL,
  `connection_status_received_at` timestamp NOT NULL DEFAULT NOW(),
	PRIMARY KEY (`connection_status_id`),
  KEY `IND_connection_status_connection_id` (`connection_status_connection_id`),
  KEY `IND_connection_status_type_id` (`connection_status_type_id`),
  KEY `IND_connection_status_received_at` (`connection_status_received_at`),
	CONSTRAINT `foreign_connection_status_connection_id`
		FOREIGN KEY (`connection_status_connection_id`)
		REFERENCES `connections` (`connection_id`),
	CONSTRAINT `foreign_connection_locations_connection_id`
		FOREIGN KEY (`connection_locations_connection_id`)
		REFERENCES `connections` (`connection_id`),
	CONSTRAINT `foreign_connection_locations_connection_id`
		FOREIGN KEY (`connection_locations_connection_id`)
		REFERENCES `connections` (`connection_id`)
};

--  END:  Connection status updates
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- START: Connection text messages

CREATE TABLE `connection_text_messages` {
  `connection_text_msg_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `connection_text_msg_connection_id` tinyint(3) unsigned NOT NULL,
  `connection_text_msg_from_sender` tinyint(1) unsigned NOT NULL,
  `connection_text_msg_packet_id` int(11) unsigned DEFAULT NULL,
  `connection_text_msg_parent_msg_id` int(11) unsigned NOT NULL,
  `connection_text_msg_status_received_at` timestamp NOT NULL DEFAULT NOW(),
  `connection_text_msg_text` TEXT NOT NULL,
	PRIMARY KEY (`connection_text_msg_id`),
  KEY `IND_connection_text_msg_connection_id` (`connection_text_msg_connection_id`),
  KEY `IND_connection_text_msg_status_received_at` (`connection_text_msg_status_received_at`),
	CONSTRAINT `foreign_connection_text_msg_connection_id`
		FOREIGN KEY (`connection_text_msg_connection_id`)
		REFERENCES `connections` (`connection_id`),
	CONSTRAINT `foreign_connection_text_msg_parent_msg_id`
		FOREIGN KEY (`connection_text_msg_parent_msg_id`)
		REFERENCES `text_messages` (`connection_text_msg_connection_id`),
	CONSTRAINT `foreign_connection_text_msg_parent_msg_id`
		FOREIGN KEY (`connection_text_msg_parent_msg_id`)
		REFERENCES `text_messages` (`connection_text_msg_connection_id`)
};

--  END:  Connection text messages
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- START: Packet queue

CREATE TABLE `packet_queue` {
  `packet_queue_expire_at` timestamp NOT NULL,
  `packet_queue_server_id` tinyint(3) unsigned NOT NULL,
  `packet_queue_account_id` tinyint(3) unsigned NOT NULL,
  `packet_queue_connection_id` tinyint(3) unsigned NOT NULL,
  `packet_queue_packet_id` int(11) unsigned NOT NULL,
  `packet_queue_recipient_id` char(40) NOT NULL,
  `packet_queue_data` blob NOT NULL,
  KEY `IND_packet_queue_expire_at` (`packet_queue_expire_at`),
	CONSTRAINT `foreign_packet_queue_connection_id`
		FOREIGN KEY (`packet_queue_connection_id`)
		REFERENCES `connections` (`connection_id`),
	CONSTRAINT `foreign_packet_queue_server_id`
		FOREIGN KEY (`packet_queue_server_id`)
		REFERENCES `server_list` (`server_id`),
	CONSTRAINT `foreign_packet_queue_account_id`
		FOREIGN KEY (`packet_queue_account_id`)
		REFERENCES `server_accounts` (`account_id`)
};

--  END:  Packet queue
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- START: Server messages

CREATE TABLE `server_messages` {
  `server_msg_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `server_msg_server_id` tinyint(3) unsigned NOT NULL,
  `server_msg_account_id` tinyint(3) unsigned NOT NULL,
  `server_msg_expire_at` timestamp NOT NULL,
  `server_msg_text` varchar(255) unsigned NOT NULL,
  `server_msg_received_at` timestamp NOT NULL DEFAULT NOW(),
  `server_msg_acknowledged` tinyint(1) unsigned NOT NULL DEFAULT 0,
	PRIMARY KEY (`server_msg_id`),
  KEY `IND_server_msg_expire_at` (`server_msg_expire_at`),
  KEY `IND_server_msg_received_at` (`server_msg_received_at`),
  KEY `IND_server_msg_acknowledged` (`server_msg_acknowledged`),
	CONSTRAINT `foreign_server_msg_server_id`
		FOREIGN KEY (`server_msg_server_id`)
		REFERENCES `server_list` (`server_id`),
	CONSTRAINT `foreign_server_msg_account_id`
		FOREIGN KEY (`server_msg_account_id`)
		REFERENCES `server_accounts` (`account_id`)
};

--  END:  Packet queue
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

--  END:  data tables
-- ===================================================================
