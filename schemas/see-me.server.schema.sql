

-- ===================================================================
-- START: enum tables

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
-- START: User accounts

CREATE TABLE `user_accounts` {
  `user_account_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_account_public_key` char(255) NOT NULL,
  `user_account_session_key` varchar(255) DEFAULT NULL,
  `user_account_session_expires` timestamp DEFAULT NULL,
  `user_account_expires` timestamp DEFAULT NULL,
	PRIMARY KEY (`movement_type_id`),

};

--  END:  User accounts
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- START: User connections

CREATE TABLE `user_connections` {
  `user_connection_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_connection_account_id` int(11) unsigned NOT NULL,
  `user_connection_pair_id` char(40) NOT NULL,
  `user_connection_access_mode` enum( 'send', 'receive' ) DEFAULT NULL,
  `user_connection_max_packet_life` mediumint(9) unsigned NOT NULL DEFAULT 302400,
	PRIMARY KEY (`movement_type_id`),
};

--  END:  User connections
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- START: Packet queue

CREATE TABLE `packet_queue` {
  `packet_queue_expire_at` timestamp NOT NULL,
  `packet_queue_packet_id` int(11) unsigned NOT NULL,
  `packet_queue_recipient_id` char(40) NOT NULL,
  `packet_queue_data` blob NOT NULL,
  KEY `IND_packet_queue_expire_at` (`packet_queue_expire_at`),
  KEY `IND_packet_queue_recipient_id` (`packet_queue_recipient_id`),
	CONSTRAINT `foreign_packet_queue_recipient_id`
		FOREIGN KEY (`packet_queue_recipient_id`)
		REFERENCES `user_connections` (`user_connection_id`)
};

--  END:  Packet queue
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- START: Pending connection requests

CREATE TABLE `pending_connection_request` {
  `pending_connection_request_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pending_connection_request_expire_at` timestamp NOT NULL,
  `pending_connection_request_initiator_id` int(11) unsigned NOT NULL,
  `pending_connection_request_sender_id` char(40) NOT NULL,
  `pending_connection_request_recipient_id` char(40) NOT NULL,
  KEY `IND_packet_queue_expire_at` (`packet_queue_expire_at`),
  KEY `IND_packet_queue_recipient_id` (`packet_queue_recipient_id`),
	CONSTRAINT `foreign_pending_connection_request_expire_at`
		FOREIGN KEY (`pending_connection_request_expire_at`)
		REFERENCES `user_connections` (`user_connection_id`)
};

--  END:  Packet queue
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

--  END:  data tables
-- ===================================================================
