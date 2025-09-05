-- MCP Server Database Schema
-- Created: September 5, 2025
-- Purpose: Store scraped data from MCP server listings website

-- Main MCP Servers table
CREATE TABLE mcp_servers (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL,
    version NVARCHAR(50),
    author_vendor NVARCHAR(255),
    published_date DATE,
    development_language NVARCHAR(100),
    license NVARCHAR(255),
    total_downloads INT DEFAULT 0,
    stars INT DEFAULT 0,
    overview NVARCHAR(MAX), -- README.md content
    installation_guide NVARCHAR(MAX),
    installation_command NVARCHAR(500),
    score_grade CHAR(1) CHECK (score_grade IN ('A', 'B', 'F')),
    score_percentage DECIMAL(5,2),
    server_type NVARCHAR(100), -- e.g., 'Local Service'
    short_description NVARCHAR(1000),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    scraped_at DATETIME2 DEFAULT GETDATE()
);

-- Installation Platforms/Methods
CREATE TABLE installation_platforms (
    id INT PRIMARY KEY IDENTITY(1,1),
    platform_name NVARCHAR(100) NOT NULL UNIQUE -- LobeChat, Claude, OpenAI, Cursor, VsCode, Cline
);

-- Junction table for MCP Server - Installation Platform relationship
CREATE TABLE mcp_server_platforms (
    id INT PRIMARY KEY IDENTITY(1,1),
    mcp_server_id INT NOT NULL,
    platform_id INT NOT NULL,
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    FOREIGN KEY (platform_id) REFERENCES installation_platforms(id) ON DELETE CASCADE,
    UNIQUE(mcp_server_id, platform_id)
);

-- System Dependencies
CREATE TABLE system_dependencies (
    id INT PRIMARY KEY IDENTITY(1,1),
    mcp_server_id INT NOT NULL,
    dependency_name NVARCHAR(100) NOT NULL,
    version_requirement NVARCHAR(100),
    is_required BIT DEFAULT 1,
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Tools/Functions exposed by MCP servers
CREATE TABLE mcp_tools (
    id INT PRIMARY KEY IDENTITY(1,1),
    mcp_server_id INT NOT NULL,
    tool_name NVARCHAR(255) NOT NULL,
    instruction_description NVARCHAR(1000),
    input_description NVARCHAR(MAX), -- JSON schema
    tool_category NVARCHAR(100),
    is_active BIT DEFAULT 1,
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Prompts available for MCP servers
CREATE TABLE mcp_prompts (
    id INT PRIMARY KEY IDENTITY(1,1),
    mcp_server_id INT NOT NULL,
    prompt_name NVARCHAR(255) NOT NULL,
    prompt_description NVARCHAR(1000),
    prompt_content NVARCHAR(MAX),
    category NVARCHAR(100),
    is_active BIT DEFAULT 1,
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Tags for categorization
CREATE TABLE tags (
    id INT PRIMARY KEY IDENTITY(1,1),
    tag_name NVARCHAR(100) NOT NULL UNIQUE -- Developer Tools, AI/ML, etc.
);

-- Junction table for MCP Server - Tags relationship
CREATE TABLE mcp_server_tags (
    id INT PRIMARY KEY IDENTITY(1,1),
    mcp_server_id INT NOT NULL,
    tag_id INT NOT NULL,
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE,
    UNIQUE(mcp_server_id, tag_id)
);

-- Version History
CREATE TABLE version_history (
    id INT PRIMARY KEY IDENTITY(1,1),
    mcp_server_id INT NOT NULL,
    version_number NVARCHAR(50) NOT NULL,
    published_date DATE,
    is_validated BIT DEFAULT 0,
    release_notes NVARCHAR(MAX),
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
--     id INT PRIMARY KEY IDENTITY(1,1),
--     source_server_id INT NOT NULL,
--     related_server_id INT NOT NULL,
--     relationship_type NVARCHAR(50) DEFAULT 'recommended', -- recommended, similar, alternative
--     relevance_score DECIMAL(3,2), -- 0.00 to 1.00
--     FOREIGN KEY (source_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
--     FOREIGN KEY (related_server_id) REFERENCES mcp_servers(id) ON DELETE NO ACTION
-- );

-- Ratings for servers (A, B, F grades)
-- -- I have no idea sir troy if this is from database or just an algorithm choosing what is the nearest match to the current server
CREATE TABLE server_ratings (
    id INT PRIMARY KEY IDENTITY(1,1),
    server_name NVARCHAR(255) NOT NULL,
    developer NVARCHAR(255),
    rating_grade CHAR(1) CHECK (rating_grade IN ('A', 'B', 'F')),
    is_premium BIT DEFAULT 0,
    total_tools INT DEFAULT 0,
    total_prompts INT DEFAULT 0,
    total_downloads INT DEFAULT 0,
    stars INT DEFAULT 0,
    short_description NVARCHAR(1000),
    published_date DATE,
    server_type NVARCHAR(100)
);

-- Create indexes for better performance
CREATE INDEX IX_mcp_servers_name ON mcp_servers(name);
CREATE INDEX IX_mcp_servers_author ON mcp_servers(author_vendor);
CREATE INDEX IX_mcp_servers_published_date ON mcp_servers(published_date);
CREATE INDEX IX_mcp_servers_score_grade ON mcp_servers(score_grade);
CREATE INDEX IX_mcp_servers_stars ON mcp_servers(stars);
CREATE INDEX IX_mcp_servers_downloads ON mcp_servers(total_downloads);
CREATE INDEX IX_mcp_tools_server_id ON mcp_tools(mcp_server_id);
CREATE INDEX IX_version_history_server_id ON version_history(mcp_server_id);
CREATE INDEX IX_version_history_date ON version_history(published_date);

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
