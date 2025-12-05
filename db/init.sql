SET NAMES 'utf8mb4';

CREATE TABLE IF NOT EXISTS items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Nouvelles données sur le Football
INSERT INTO items (name, description) VALUES ('Coupe du Monde 1998', 'La France remporte sa première étoile face au Brésil (3-0).');
INSERT INTO items (name, description) VALUES ('Zinédine Zidane', 'Légende du football, célèbre pour sa volée en 2002 et sa roulette.');
INSERT INTO items (name, description) VALUES ('Le Ballon d''Or', 'Récompense individuelle prestigieuse remise au meilleur joueur de l''année.');