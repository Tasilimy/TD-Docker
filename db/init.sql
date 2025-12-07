SET NAMES 'utf8mb4';

-- 2. Création de la base de données
CREATE DATABASE IF NOT EXISTS appdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 3. Sélection de la base de données
USE appdb;

-- 4. Création de la table des éléments
CREATE TABLE IF NOT EXISTS items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Insertion de données initiales
INSERT INTO items (name, description) VALUES 
('Coupe du Monde 1998', 'La France remporte sa première étoile face au Brésil (3-0).'),
('Zinédine Zidane', 'Légende du football, célèbre pour sa volée en 2002 et sa roulette.'),
('Le Ballon d''Or', 'Récompense individuelle remise au meilleur joueur de l''année.'),
('Ousmane Dembélé', 'Ballon d''Or et saison historique en attaque.'),
('PSG Champion d''Europe', 'Le PSG remporte la Ligue des Champions.');