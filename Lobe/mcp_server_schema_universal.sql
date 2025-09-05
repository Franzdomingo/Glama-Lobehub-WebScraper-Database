-- MCP Server Database Schema - Universal Version
-- Created: September 5, 2025
-- Purpose: Store scraped data from MCP server listings website
-- Compatible with: MySQL, PostgreSQL, SQLite

-- Main MCP Servers table
CREATE TABLE mcp_servers (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    version VARCHAR(50),
    author_vendor VARCHAR(255),
    published_date DATE,
    development_language VARCHAR(100),
    license VARCHAR(255),
    total_downloads INTEGER DEFAULT 0,
    stars INTEGER DEFAULT 0,
    overview TEXT, -- README.md content
    installation_guide TEXT,
    installation_command VARCHAR(500),
    score_grade CHAR(1) CHECK (score_grade IN ('A', 'B', 'F')),
    score_percentage DECIMAL(5,2),
    server_type VARCHAR(100), -- e.g., 'Local Service'
    short_description VARCHAR(1000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    scraped_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Installation Platforms/Methods
CREATE TABLE installation_platforms (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    platform_name VARCHAR(100) NOT NULL UNIQUE -- LobeChat, Claude, OpenAI, Cursor, VsCode, Cline
);

-- Junction table for MCP Server - Installation Platform relationship
CREATE TABLE mcp_server_platforms (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    mcp_server_id INTEGER NOT NULL,
    platform_id INTEGER NOT NULL,
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    FOREIGN KEY (platform_id) REFERENCES installation_platforms(id) ON DELETE CASCADE,
    UNIQUE(mcp_server_id, platform_id)
);

-- System Dependencies
CREATE TABLE system_dependencies (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    mcp_server_id INTEGER NOT NULL,
    dependency_name VARCHAR(100) NOT NULL,
    version_requirement VARCHAR(100),
    is_required BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Tools/Functions exposed by MCP servers
CREATE TABLE mcp_tools (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    mcp_server_id INTEGER NOT NULL,
    tool_name VARCHAR(255) NOT NULL,
    instruction_description VARCHAR(1000),
    input_description TEXT, -- JSON schema
    tool_category VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Prompts available for MCP servers
CREATE TABLE mcp_prompts (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    mcp_server_id INTEGER NOT NULL,
    prompt_name VARCHAR(255) NOT NULL,
    prompt_description VARCHAR(1000),
    prompt_content TEXT,
    category VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Tags for categorization
CREATE TABLE tags (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    tag_name VARCHAR(100) NOT NULL UNIQUE -- Developer Tools, AI/ML, etc.
);

-- Junction table for MCP Server - Tags relationship
CREATE TABLE mcp_server_tags (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    mcp_server_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE,
    UNIQUE(mcp_server_id, tag_id)
);

-- Version History
CREATE TABLE version_history (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    mcp_server_id INTEGER NOT NULL,
    version_number VARCHAR(50) NOT NULL,
    published_date DATE,
    is_validated BOOLEAN DEFAULT FALSE,
    release_notes TEXT,
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Related/Recommended MCP Servers
-- Related/Recommended MCP Servers
-- NOTE: Related servers are surfaced by a front-end recommendation algorithm
-- and are not strictly necessary to store in the core database schema.
-- The table definition is retained here commented out in case you later
-- decide to persist recommendations server-side.
--
-- CREATE TABLE related_servers (
--     id INTEGER PRIMARY KEY AUTO_INCREMENT,
--     source_server_id INTEGER NOT NULL,
--     related_server_id INTEGER NOT NULL,
--     relationship_type VARCHAR(50) DEFAULT 'recommended', -- recommended, similar, alternative
--     relevance_score DECIMAL(3,2), -- 0.00 to 1.00
--     FOREIGN KEY (source_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
--     FOREIGN KEY (related_server_id) REFERENCES mcp_servers(id) ON DELETE SET NULL
-- );

-- Ratings for servers (A, B, F grades)
CREATE TABLE server_ratings (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    server_name VARCHAR(255) NOT NULL,
    developer VARCHAR(255),
    rating_grade CHAR(1) CHECK (rating_grade IN ('A', 'B', 'F')),
    is_premium BOOLEAN DEFAULT FALSE,
    total_tools INTEGER DEFAULT 0,
    total_prompts INTEGER DEFAULT 0,
    total_downloads INTEGER DEFAULT 0,
    stars INTEGER DEFAULT 0,
    short_description VARCHAR(1000),
    published_date DATE,
    server_type VARCHAR(100)
);

-- Create indexes for better performance
CREATE INDEX idx_mcp_servers_name ON mcp_servers(name);
CREATE INDEX idx_mcp_servers_author ON mcp_servers(author_vendor);
CREATE INDEX idx_mcp_servers_published_date ON mcp_servers(published_date);
CREATE INDEX idx_mcp_servers_score_grade ON mcp_servers(score_grade);
CREATE INDEX idx_mcp_servers_stars ON mcp_servers(stars);
CREATE INDEX idx_mcp_servers_downloads ON mcp_servers(total_downloads);
CREATE INDEX idx_mcp_tools_server_id ON mcp_tools(mcp_server_id);
CREATE INDEX idx_version_history_server_id ON version_history(mcp_server_id);
CREATE INDEX idx_version_history_date ON version_history(published_date);

-- Insert some common installation platforms
INSERT INTO installation_platforms (platform_name) VALUES 
('LobeChat'),
('Claude'),
('OpenAI'),
('Cursor'),
('VsCode'),
('Cline');

-- Insert common tags
INSERT INTO tags (tag_name) VALUES 
('Developer Tools'),
('Productivity Tools'),
('Utility Tools'),
('Information Retrieval'),
('Media Generation'),
('Business Services'),
('Science & Education'),
('Stocks & Finance'),
('News & Information'),
('Social Media'),
('Gaming & Entertainment'),
('Lifestyle'),
('Health & Wellness'),
('Travel & Transport'),
('Weather');
