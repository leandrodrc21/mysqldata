CREATE USER 'admin'@'localhost' IDENTIFIED BY '134679';
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;
CREATE USER 'admin'@'%' IDENTIFIED BY '134679';
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;
CREATE USER  'php'@'localhost' identified by '12345678';
CREATE USER 'php'@'%' IDENTIFIED BY '134679';
GRANT ALL PRIVILEGES ON miphp.* TO php@localhost;
FLUSH PRIVILEGES;
create database miphp;
use miphp;
CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `Name` varchar(60) NOT NULL,
  `Email` varchar(120) NOT NULL,
  `Password` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
CREATE TABLE `log_tablas` (
  `id` int(11) NOT NULL,
  `nombre_tabla` varchar(120) NOT NULL,
  `situacion` varchar(2) NOT NULL DEFAULT 'NA',
  `fecha` date NOT NULL,
  `validacion` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DELIMITER $$
CREATE TRIGGER `trg_users` AFTER INSERT ON `users` FOR EACH ROW INSERT INTO `backup_modificaciones` (`id`, `nombre_tabla`, `situacion`, `fecha`, `validacion`) VALUES (new.id, 'users', 'NA', CURDATE(), 'INSERT')
$$
DELIMITER ;
SET GLOBAL event_scheduler = ON;
SET @@GLOBAL.event_scheduler = ON;
SET GLOBAL event_scheduler = 1;
SET @@GLOBAL.event_scheduler = 1;
DELIMITER $$
CREATE TRIGGER `trg_users_update` BEFORE UPDATE ON `users` FOR EACH ROW INSERT INTO `backup_modificaciones` (`id`, `nombre_tabla`, `situacion`, `fecha`, `validacion`) VALUES (new.id, 'users', 'NA', CURDATE(), 'UPDATE')
$$
DELIMITER ;
DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`%` PROCEDURE `crearArchivo` (IN `nombreA` VARCHAR(50))  NO SQL
BEGIN
DECLARE namef varchar(200);
DECLARE numeroProcesador int;
    

   set numeroProcesador= (SELECT COUNT(*) FROM `log_tablas` where `situacion`='NA');
   
  IF  (numeroProcesador =  0) THEN
           SET numeroProcesador = 0;
   ELSE
    
    select concat( '/var/lib/mysql-files/',
                  nombreA,'_',
     substr( cast(current_timestamp() as char),1,4),
     substr(cast(current_timestamp() as char),6,2),
     substr(cast(current_timestamp() as char),9,2),
     substr(cast(current_timestamp() as char),12,2),
     substr(cast(current_timestamp() as char),15,2),
     substr(cast(current_timestamp() as char),18,2),'.sql') as salida
     into namef from dual;
    SELECT CONCAT("SELECT * INTO OUTFILE '",namef,"' FROM `users`  ") INTO @SQL;
PREPARE stmt FROM @SQL;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
UPDATE log_tablas
SET situacion='OK' WHERE situacion='NA';

    END IF;  
    
  
    
 END$$

DELIMITER ;

DELIMITER $$

CREATE DEFINER=`admin`@`%` EVENT `crearRespaldo` ON SCHEDULE EVERY 5 MINUTE STARTS '2019-10-25 00:00:00' ENDS '2019-10-26 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL `crearArchivo`('users')$$

DELIMITER ;


COMMIT;


