-- Base D1 de larretgourmand.com
-- À exécuter une fois : npx wrangler d1 execute larret-gourmand --remote --file=schema.sql

CREATE TABLE IF NOT EXISTS burgers (
  id TEXT PRIMARY KEY,                  -- identifiant stable (slug), ex. 'poulet'
  nom TEXT NOT NULL,
  accroche TEXT NOT NULL DEFAULT '',    -- petite phrase sous le nom (ex. "Can I get some Burger ?")
  description TEXT NOT NULL DEFAULT '', -- la composition
  photo TEXT NOT NULL DEFAULT '',       -- chemin de la photo : /img/xxx.jpg (fichier du site) ou /photos/xxx.jpg (envoyée depuis l'admin)
  supplement REAL NOT NULL DEFAULT 0,   -- en euros, s'ajoute au prix du burger (ex. L'Américain : 1)
  actif INTEGER NOT NULL DEFAULT 1,     -- 0 = retiré de la carte (masqué sur le site)
  rupture_jusqua TEXT,                  -- 'YYYY-MM-DD' : affiché "Épuisé ce soir" jusqu'à cette date incluse
  ordre INTEGER NOT NULL DEFAULT 0      -- ordre d'affichage ; le premier est mis en avant (grande carte)
);

CREATE TABLE IF NOT EXISTS emplacements (
  id TEXT PRIMARY KEY,            -- 'mardi', 'jeudi', 'vendredi', 'samedi'
  jour INTEGER NOT NULL,          -- 0 = dimanche … 6 = samedi
  ville TEXT NOT NULL,
  lieu TEXT NOT NULL,
  map_url TEXT,
  heures TEXT NOT NULL DEFAULT 'de 19h à 20h30',
  actif INTEGER NOT NULL DEFAULT 1,     -- 0 = emplacement suspendu
  ordre INTEGER NOT NULL DEFAULT 0
);

-- Une exception = une date précise annulée ou déplacée
CREATE TABLE IF NOT EXISTS exceptions (
  date TEXT PRIMARY KEY,          -- 'YYYY-MM-DD'
  annule INTEGER NOT NULL DEFAULT 1,    -- 1 = pas de service ce jour-là
  ville TEXT,                     -- si annule = 0 : lieu de remplacement
  lieu TEXT,
  map_url TEXT,
  heures TEXT,
  message TEXT                    -- ex. "Congés", "Privatisation", "Marché de Noël"
);

CREATE TABLE IF NOT EXISTS reglages (
  cle TEXT PRIMARY KEY,
  valeur TEXT
);

CREATE TABLE IF NOT EXISTS demandes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  recu_le TEXT NOT NULL DEFAULT (datetime('now')),
  nom TEXT, tel TEXT, email TEXT,
  type TEXT, date_event TEXT, convives TEXT, lieu TEXT, message TEXT,
  page TEXT,                      -- page d'origine (/, /food-truck-mariage…)
  statut TEXT NOT NULL DEFAULT 'nouveau',   -- nouveau | repondu | signe | perdu
  mail_envoye INTEGER NOT NULL DEFAULT 0
);

-- ---------- Données initiales ----------
INSERT OR IGNORE INTO burgers (id, nom, accroche, description, photo, supplement, ordre) VALUES
  ('poulet',     'Burger au poulet', 'Votre nouveau burger au poulet préféré !',
   'Un bun boulanger, du Poulet Français croustillant maison, du cheddar, une sauce Ranch maison, des oignons frits et du mesclun !', '/img/poulet.jpg', 0, 1),
  ('americain',  'L''Américain', 'Can I get some Burger ?',
   'Un bun boulanger, 150g de Bœuf Charolais Français, double cheddar, de la poitrine fumée, des oignons frits et une sauce burger !', '/img/americain.jpg', 1, 2),
  ('dragon',     'Le Dragon', '',
   'Un bun boulanger, 150g de Bœuf Charolais Français, du cheddar, des poivrons rouges épicés maison, une sauce épicée maison et du mesclun !', '/img/dragon.jpg', 0, 3),
  ('original',   'L''Original', 'Steak VG sur demande',
   'Un bun boulanger, 150g de Bœuf Charolais Français, du cheddar, des lamelles d''oignons rouges, des tranches de cornichons à l''aigre-douce, une tranche de tomate fraîche et du mesclun !', '/img/original.jpg', 0, 4),
  ('bbq',        'Le BBQ', 'Vous avez dit « une sauce BBQ » ?',
   'Un bun boulanger, 150g de Bœuf Charolais Français, du cheddar, des oignons frits, de la poitrine fumée, une sauce BBQ et du mesclun !', '/img/bbq.jpg', 0, 5),
  ('montagnard', 'Le Montagnard', 'Restez sur les pistes avec Le Montagnard !',
   'Un bun boulanger, 150g de Bœuf Charolais Français, du reblochon, de la poitrine fumée, des chips allumettes et du mesclun !', '/img/montagnard.jpg', 0, 6),
  ('myko',       'Le Myko', 'Le meilleur mélange sucré-salé dans un Burger !',
   'Un bun boulanger, 150g de Bœuf Charolais Français, du fromage de chèvre, de la poitrine fumée, du miel et du mesclun !', '/img/myko.jpg', 0, 7);

INSERT OR IGNORE INTO emplacements (id, jour, ville, lieu, map_url, ordre) VALUES
  ('mardi',    2, 'Triel-sur-Seine',       'Centre commercial des Châtelaines',                          'https://share.google/W1bbwJr7yw12RIJHI', 1),
  ('jeudi',    4, 'Verneuil-sur-Seine',    'Gare de Vernouillet Verneuil',                               'https://share.google/BpG23vPr2k8v9Eb2n', 2),
  ('vendredi', 5, 'Carrières-sous-Poissy', 'Angle Rue de la Reine Blanche et Chemin de Beauregard',      'https://share.google/NqgV3Ng4yHxsIs2em', 3),
  ('samedi',   6, 'Carrières-sous-Poissy', 'Place Saint-Blaise - Face à la pharmacie et à la Police Municipale', 'https://share.google/NqgV3Ng4yHxsIs2em', 4);

INSERT OR IGNORE INTO reglages (cle, valeur) VALUES
  ('prix_burger',        '11'),
  ('prix_menu_frites',   '13.5'),
  ('prix_menu_complet',  '15.5'),
  ('prix_frites',        '3.5'),
  ('bandeau',            '');
