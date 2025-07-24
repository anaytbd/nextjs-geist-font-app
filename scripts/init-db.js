const sqlite3 = require('sqlite3').verbose();
const fs = require('fs');
const path = require('path');

async function initializeDatabase() {
  const dbPath = path.join(process.cwd(), 'database.sqlite');
  const migrationPath = path.join(process.cwd(), 'migrations', 'init.sql');
  
  // Remove existing database file
  if (fs.existsSync(dbPath)) {
    fs.unlinkSync(dbPath);
    console.log('Removed existing database file');
  }
  
  const db = new sqlite3.Database(dbPath);
  
  try {
    // Read and execute migration SQL
    const migrationSQL = fs.readFileSync(migrationPath, 'utf8');
    
    await new Promise((resolve, reject) => {
      db.exec(migrationSQL, (err) => {
        if (err) {
          reject(err);
        } else {
          resolve();
        }
      });
    });
    
    console.log('Database schema created successfully');
    
    // Insert sample data
    const sampleData = `
      -- Insert sample employees
      INSERT OR IGNORE INTO employees (id, name, employeeId, department, joiningDate, phone, email, isActive, createdAt) VALUES
        ('EMP001', 'John Doe', 'EMP001', 'Engineering', '2023-01-15', '+880-1234567890', 'john.doe@company.com', 1, '2023-01-15T00:00:00Z'),
        ('EMP002', 'Jane Smith', 'EMP002', 'Marketing', '2023-02-20', '+880-1234567891', 'jane.smith@company.com', 1, '2023-02-20T00:00:00Z'),
        ('EMP003', 'Mike Johnson', 'EMP003', 'Sales', '2023-03-10', '+880-1234567892', 'mike.johnson@company.com', 1, '2023-03-10T00:00:00Z');
      
      -- Insert sample menu items
      INSERT OR IGNORE INTO menu_items (id, name, category, price, isEnabled, createdAt) VALUES
        ('MENU001', 'Steamed Rice', 'Rice', 25, 1, '2023-01-01T00:00:00Z'),
        ('MENU002', 'Chicken Curry', 'Curry', 80, 1, '2023-01-01T00:00:00Z'),
        ('MENU003', 'Fish Fry', 'Fish', 90, 1, '2023-01-01T00:00:00Z'),
        ('MENU004', 'Mixed Vegetables', 'Vegetable', 40, 1, '2023-01-01T00:00:00Z'),
        ('MENU005', 'Dal (Lentils)', 'Curry', 30, 1, '2023-01-01T00:00:00Z'),
        ('MENU006', 'Beef Curry', 'Curry', 100, 1, '2023-01-01T00:00:00Z'),
        ('MENU007', 'Fried Rice', 'Rice', 60, 1, '2023-01-01T00:00:00Z'),
        ('MENU008', 'Fish Curry', 'Fish', 85, 1, '2023-01-01T00:00:00Z'),
        ('MENU009', 'Kheer', 'Dessert', 35, 1, '2023-01-01T00:00:00Z'),
        ('MENU010', 'Soft Drink', 'Drink', 20, 0, '2023-01-01T00:00:00Z');
      
      -- Insert sample daily menu
      INSERT OR IGNORE INTO daily_menus (id, date, notes, isLocked, createdAt) VALUES
        ('DAILY001', date('now'), 'Regular lunch menu', 0, datetime('now'));
      
      -- Insert daily menu items
      INSERT OR IGNORE INTO daily_menu_items (dailyMenuId, menuItemId) VALUES
        ('DAILY001', 'MENU001'),
        ('DAILY001', 'MENU002'),
        ('DAILY001', 'MENU004'),
        ('DAILY001', 'MENU005');
    `;
    
    await new Promise((resolve, reject) => {
      db.exec(sampleData, (err) => {
        if (err) {
          reject(err);
        } else {
          resolve();
        }
      });
    });
    
    console.log('Sample data inserted successfully');
    console.log('Database initialization completed!');
    
  } catch (error) {
    console.error('Error initializing database:', error);
  } finally {
    db.close();
  }
}

initializeDatabase();
