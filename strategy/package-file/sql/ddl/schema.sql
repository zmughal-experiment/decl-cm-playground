CREATE TABLE IF NOT EXISTS distributions (
  id   INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  UNIQUE(name)
);

CREATE TABLE IF NOT EXISTS package_files (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  distribution_id INTEGER NOT NULL,
  package         TEXT NOT NULL,
  file            TEXT NOT NULL,
  FOREIGN KEY (distribution_id) REFERENCES distributions(id)
);
