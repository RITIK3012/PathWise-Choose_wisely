-- Create user table if it doesn't exist
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    enabled BOOLEAN DEFAULT TRUE
);

-- Create role table if it doesn't exist
CREATE TABLE IF NOT EXISTS roles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Create user_roles join table if it doesn't exist
CREATE TABLE IF NOT EXISTS user_roles (
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (role_id) REFERENCES roles(id)
);

-- Insert default roles if they don't exist
INSERT IGNORE INTO roles (name) VALUES 
('ROLE_USER'),
('ROLE_ADMIN');

-- Insert default admin user with encrypted password 'admin123'
-- Note: In production, use a proper password hashing mechanism
INSERT IGNORE INTO users (username, password, email, full_name, enabled)
SELECT 'admin', '$2a$10$NVM0n8ElaRgg7zWO1CxUdei7vWoPg91Lz2aYavh9.f9q0e4bRadue', 'admin@pathwise.com', 'System Administrator', TRUE
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'admin');

-- Assign admin role to admin user
INSERT IGNORE INTO user_roles (user_id, role_id)
SELECT u.id, r.id FROM users u, roles r
WHERE u.username = 'admin' AND r.name = 'ROLE_ADMIN'
AND NOT EXISTS (
    SELECT 1 FROM user_roles ur 
    JOIN users u2 ON ur.user_id = u2.id 
    JOIN roles r2 ON ur.role_id = r2.id 
    WHERE u2.username = 'admin' AND r2.name = 'ROLE_ADMIN'
); 