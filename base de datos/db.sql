-- Schema db
CREATE SCHEMA IF NOT EXISTS `db` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;

USE `db`;

-- Table `db`.`images`
CREATE TABLE IF NOT EXISTS `db`.`images` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `file_path` TEXT NOT NULL,
  `file_name` TEXT NOT NULL,
  `file_extension` TEXT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB;


-- Table `db`.`users`
CREATE TABLE IF NOT EXISTS `db`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `is_admin` TINYINT(1) NOT NULL DEFAULT 0,
  `first_name` VARCHAR(25) NOT NULL,
  `last_name` VARCHAR(25) NOT NULL,
  `full_name` VARCHAR(51) NOT NULL,
  `photo_id` INT NOT NULL,
  `phone_number` VARCHAR(10) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `password` TEXT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_users_images_idx` (`photo_id` ASC),
  CONSTRAINT `fk_users_images`
    FOREIGN KEY (`photo_id`)
    REFERENCES `db`.`images` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;


-- Table `db`.`categories`
CREATE TABLE IF NOT EXISTS `db`.`categories` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `slug` VARCHAR(60) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB;


-- Table `db`.`plates`
CREATE TABLE IF NOT EXISTS `db`.`plates` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `slug` VARCHAR(60) NULL,
  `description` TEXT NULL,
  `price` DECIMAL(6,2) NULL,
  `category_id` INT NOT NULL,
  `image_id` INT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_plates_categories_idx` (`category_id` ASC),
  INDEX `fk_plates_images_idx` (`image_id` ASC),
  CONSTRAINT `fk_plates_categories`
    FOREIGN KEY (`category_id`)
    REFERENCES `db`.`categories` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_plates_images`
    FOREIGN KEY (`image_id`)
    REFERENCES `db`.`images` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- Table `db`.`orders`
CREATE TABLE IF NOT EXISTS `db`.`orders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `address` TEXT NOT NULL,
  `comment` TEXT NULL,
  `user_id` INT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_orders_users_idx` (`user_id` ASC),
  CONSTRAINT `fk_orders_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `db`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- Table `db`.`orders_has_plates`
CREATE TABLE IF NOT EXISTS `db`.`orders_has_plates` (
  `order_id` INT NOT NULL,
  `plate_id` INT NOT NULL,
  `amount`   INT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `fk_orders_has_plates_plates_idx` (`plate_id` ASC),
  INDEX `fk_orders_has_plates_orders_idx` (`order_id` ASC),
  CONSTRAINT `fk_orders_has_plates_orders`
    FOREIGN KEY (`order_id`)
    REFERENCES `db`.`orders` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_has_plates_plates`
    FOREIGN KEY (`plate_id`)
    REFERENCES `db`.`plates` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- Table `db`.`invoices`
CREATE TABLE IF NOT EXISTS `db`.`invoices` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `subtotal` DECIMAL(8,2) NOT NULL,
  `iva` DECIMAL(5,2) NOT NULL,
  `total` DECIMAL(8,2) NOT NULL,
  `order_id` INT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_invoices_orders_idx` (`order_id` ASC),
  CONSTRAINT `fk_invoices_orders`
    FOREIGN KEY (`order_id`)
    REFERENCES `db`.`orders` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- ***** INITIAL VALUES *****

-- Seeding "User Photo" by default:
INSERT INTO `db`.`images` (`file_path`, `file_name`, `file_extension`)
		VALUES ('/public/users/img_profile', 'img_default', 'png');

-- Seeding "Plate Image" by default:
INSERT INTO `db`.`images` (`file_path`, `file_name`, `file_extension`) 
    VALUES('/public/plates/img', 'img_default', 'png');

-- Seeding "Plate images":
INSERT INTO `db`.`images` (`file_path`, `file_name`, `file_extension`) 
    VALUES('/public/plates/img', 'img-20180607-131313-hamburguesa-de-res', 'jpg');

INSERT INTO `db`.`images` (`file_path`, `file_name`, `file_extension`) 
    VALUES('/public/plates/img', 'img-20180607-131829-pizza-con-extra-queso', 'jpg');

INSERT INTO `db`.`images` (`file_path`, `file_name`, `file_extension`) 
    VALUES('/public/plates/img', 'img-20180607-ensalada', 'jpg');
    
INSERT INTO `db`.`images` (`file_path`, `file_name`, `file_extension`) 
    VALUES('/public/plates/img', 'img-20180607-papas-a-la-francesa', 'jpg');
    
INSERT INTO `db`.`images` (`file_path`, `file_name`, `file_extension`) 
    VALUES('/public/plates/img', 'img-20180607-ensalada-frutal', 'jpg');
    
INSERT INTO `db`.`images` (`file_path`, `file_name`, `file_extension`) 
    VALUES('/public/plates/img', 'img-20180607-nuggets-de-pollo', 'jpg');
    
INSERT INTO `db`.`images` (`file_path`, `file_name`, `file_extension`) 
    VALUES('/public/plates/img', 'img-20180607-pasta-marisco', 'jpg');

-- Seeding "Categories":
INSERT INTO `db`.`categories` (`name`, `slug`) 
    VALUES('comida rápida', 'comida-rapida');

INSERT INTO `db`.`categories` (`name`, `slug`) 
    VALUES('ensaladas', 'ensaladas');

INSERT INTO `db`.`categories` (`name`, `slug`) 
    VALUES('pastas', 'pastas');

-- Seeding "Plates":
INSERT INTO `db`.`plates` (`name`, `slug`, `description`, `price`, `category_id`, `image_id`) 
      VALUES('hamburguesa de res', 'hamburguesa-de-res', 
             'Rica hamburguesa de res, con lechuga, jitomate, queso amarillo y pepinillos.', 
             49.90, 1, 3);

INSERT INTO `db`.`plates` (`name`, `slug`, `description`, `price`, `category_id`, `image_id`) 
      VALUES('Pizza con extra queso', 'pizza-con-extra-queso', 
             'Deliciosa Pizza con Extra Queso, acompañada de Peperoni y Orilla Gruesa.', 
             99, 1, 4);
             
INSERT INTO `db`.`plates` (`name`, `slug`, `description`, `price`, `category_id`, `image_id`) 
      VALUES('Papas a la francesa', 'papas-a-la-francesa',
             'Porción de papas fritas, crujientes y doradas a la perfección.', 
             25.90, 1, 6);

INSERT INTO `db`.`plates` (`name`, `slug`, `description`, `price`, `category_id`, `image_id`) 
      VALUES('Nuggets de pollo', 'nuggets-de-pollo', 
             'Ricos trocitos de pollo empanizados.', 
             35.50, 1, 8); 
             
INSERT INTO `db`.`plates` (`name`, `slug`, `description`, `price`, `category_id`, `image_id`) 
      VALUES('Ensalada', 'ensalada', 
             'Ensalada con lechuga, tomates y pequeños trozos de pollo',
             89.99, 2, 5); 
      
INSERT INTO `db`.`plates` (`name`, `slug`, `description`, `price`, `category_id`, `image_id`) 
      VALUES('Ensalada frutal', 'ensalada-frutal', 
             'Ensalada de diversas frutas como fresa, platano, kiwi, frambuesas y uvas.', 
             80.00, 2, 7);
             
INSERT INTO `db`.`plates` (`name`, `slug`, `description`, `price`, `category_id`, `image_id`) 
      VALUES('Pasta con mariscos', 'pasta-marisco', 
             'Exquisita pasta con camarón', 
             110.00, 3, 9);
      
-- Seeding "Admin Users":

INSERT INTO `users` (`id`, `is_admin`, `first_name`, `last_name`, `full_name`, `photo_id`, `phone_number`, `email`, `password`, `created_at`, `updated_at`) VALUES
(1, 1, 'Michael Brandon', 'Serrato Guerrero', 'Michael Brandon Serrato Guerrero', 1, '4422332139', 'mikebsg01@gmail.com', 'b460b1982188f11d175f60ed670027e1afdd16558919fe47023ecd38329e0b7f', '2020-09-06 02:06:08', '2020-09-06 02:06:08'),
(2, 1, 'Perla Elizabeth', 'Aguilar Maldonado', 'Perla Elizabeth Aguilar Maldonado', 1, '4422334455', 'perla.aguilar@gmail.com', 'b460b1982188f11d175f60ed670027e1afdd16558919fe47023ecd38329e0b7f', '2020-09-06 02:06:08', '2020-09-06 02:06:08'),
(3, 0, 'brayan ', 'clavijo', 'brayan  clavijo', 1, '1234567890', 'brayancapo15@gmail.com', '9394efecbd1ff7e2156491eb84a80441dadd3f9186516773aad529eb2605f151', '2020-09-06 02:08:27', '2020-09-06 02:08:27');

