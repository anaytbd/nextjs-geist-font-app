-- migrations/init.sql

-- Users Table (for authentication)
CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  email TEXT UNIQUE,
  password TEXT NOT NULL,  -- store hashed password in production
  role TEXT NOT NULL,      -- 'admin' or 'employee'
  employeeId TEXT,
  createdAt TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Sessions Table (persisting sessions instead of in-memory map)
CREATE TABLE IF NOT EXISTS sessions (
  sessionId TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  role TEXT NOT NULL,
  employeeId TEXT,
  createdAt TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Employees Table
CREATE TABLE IF NOT EXISTS employees (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  employeeId TEXT UNIQUE NOT NULL,
  department TEXT NOT NULL,
  joiningDate TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT,
  isActive INTEGER NOT NULL DEFAULT 1,
  createdAt TEXT NOT NULL
);

-- Menu Items Table
CREATE TABLE IF NOT EXISTS menu_items (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL, -- 'Rice', 'Curry', 'Fish', etc.
  price REAL NOT NULL,
  isEnabled INTEGER NOT NULL DEFAULT 1,
  createdAt TEXT NOT NULL
);

-- Daily Menus Table
CREATE TABLE IF NOT EXISTS daily_menus (
  id TEXT PRIMARY KEY,
  date TEXT UNIQUE NOT NULL,
  notes TEXT,
  isLocked INTEGER NOT NULL DEFAULT 0,
  createdAt TEXT NOT NULL
);

-- A junction table for Daily Menu Items (to store menuItems IDs)
CREATE TABLE IF NOT EXISTS daily_menu_items (
  dailyMenuId TEXT,
  menuItemId TEXT,
  PRIMARY KEY (dailyMenuId, menuItemId),
  FOREIGN KEY (dailyMenuId) REFERENCES daily_menus(id),
  FOREIGN KEY (menuItemId) REFERENCES menu_items(id)
);

-- Orders Table
CREATE TABLE IF NOT EXISTS orders (
  id TEXT PRIMARY KEY,
  employeeId TEXT NOT NULL,
  date TEXT NOT NULL,
  totalCost REAL NOT NULL,
  status TEXT NOT NULL, -- 'pending', 'confirmed', 'cancelled'
  createdAt TEXT NOT NULL
);

-- Order Items Table (junction table for order menu items)
CREATE TABLE IF NOT EXISTS order_items (
  orderId TEXT,
  menuItemId TEXT,
  PRIMARY KEY (orderId, menuItemId),
  FOREIGN KEY (orderId) REFERENCES orders(id),
  FOREIGN KEY (menuItemId) REFERENCES menu_items(id)
);

-- Payments Table
CREATE TABLE IF NOT EXISTS payments (
  id TEXT PRIMARY KEY,
  employeeId TEXT NOT NULL,
  amount REAL NOT NULL,
  date TEXT NOT NULL,
  notes TEXT,
  createdAt TEXT NOT NULL
);

-- Insert default admin user
INSERT OR IGNORE INTO users (id, username, email, password, role, createdAt) 
VALUES ('1', 'admin', 'admin@company.com', 'password123', 'admin', datetime('now'));

-- Insert default employee users
INSERT OR IGNORE INTO users (id, username, email, password, role, employeeId, createdAt) 
VALUES 
  ('2', 'john.doe', 'john.doe@company.com', 'password123', 'employee', 'EMP001', datetime('now')),
  ('3', 'jane.smith', 'jane.smith@company.com', 'password123', 'employee', 'EMP002', datetime('now'));
