-- Seed accounts for local / first-boot testing.
USE `gbth`;

INSERT INTO `user` (
  `UserId`, `Gender`, `Password`, `Status`, `MuteTime`, `RestrictTime`,
  `Authority`, `Authority2`, `AuthorityBackup`, `E_Mail`, `Country`,
  `User_Level`, `Dia`, `Mes`, `Ano`, `Created`
) VALUES
  ('admin',  0, 'admin',  '', '2000-01-01 08:00:00', '2000-01-01 00:00:00', 99, 99, 99, 'admin@localhost',  0, 1, 1, 1, 2000, NOW()),
  ('player', 0, 'player', '', '2000-01-01 08:00:00', '2000-01-01 00:00:00',  1,  1,  1, 'player@localhost', 0, 0, 1, 1, 2000, NOW())
ON DUPLICATE KEY UPDATE `Password` = VALUES(`Password`);

INSERT INTO `game` (
  `UserId`, `NickName`, `Guild`, `Gold`, `Cash`,
  `TotalScore`, `SeasonScore`, `TotalGrade`, `SeasonGrade`,
  `GiftProhibitTime`, `CorGameTime`, `CorGameBalaoTime`, `LastUpdateTime`
) VALUES
  ('admin',  'Admin',  '', 999999, 99999, 1000, 1000, 19, 19, '2000-01-01 08:00:00', '2000-01-01 08:00:00', '2000-01-01 08:00:00', NOW()),
  ('player', 'Player', '', 100000,  5000, 1000, 1000, 19, 19, '2000-01-01 08:00:00', '2000-01-01 08:00:00', '2000-01-01 08:00:00', NOW())
ON DUPLICATE KEY UPDATE `Gold` = VALUES(`Gold`);

INSERT INTO `cash` (`UserId`, `Cash`) VALUES
  ('admin', 99999),
  ('player', 5000)
ON DUPLICATE KEY UPDATE `Cash` = VALUES(`Cash`);
