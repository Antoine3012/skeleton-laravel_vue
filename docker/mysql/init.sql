CREATE DATABASE IF NOT EXISTS `default_test_db`;

GRANT ALL PRIVILEGES ON `default_test_db`.* TO 'default_user'@'%';

FLUSH PRIVILEGES;
