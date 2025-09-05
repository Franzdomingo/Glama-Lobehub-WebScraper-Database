-- Glama.ai MCP Server Database Schema
-- Created: September 5, 2025
-- Purpose: Store scraped data from glama.ai MCP server directory 
-- trial by fire: database Schema for glama.ai MCP servers 9/5/2025

-- Drop tables if they exist (for clean reinstall)
IF OBJECT_ID('server_score_criteria', 'U') IS NOT NULL DROP TABLE server_score_criteria;
IF OBJECT_ID('mcp_api_endpoints', 'U') IS NOT NULL DROP TABLE mcp_api_endpoints;
IF OBJECT_ID('mcp_tools', 'U') IS NOT NULL DROP TABLE mcp_tools;
IF OBJECT_ID('mcp_resources', 'U') IS NOT NULL DROP TABLE mcp_resources;
IF OBJECT_ID('mcp_prompts', 'U') IS NOT NULL DROP TABLE mcp_prompts;
IF OBJECT_ID('server_environment_variables', 'U') IS NOT NULL DROP TABLE server_environment_variables;
IF OBJECT_ID('server_categories', 'U') IS NOT NULL DROP TABLE server_categories;
IF OBJECT_ID('server_links', 'U') IS NOT NULL DROP TABLE server_links;
IF OBJECT_ID('categories', 'U') IS NOT NULL DROP TABLE categories;
IF OBJECT_ID('link_types', 'U') IS NOT NULL DROP TABLE link_types;
IF OBJECT_ID('mcp_servers', 'U') IS NOT NULL DROP TABLE mcp_servers;

-- Main MCP Servers table
CREATE TABLE mcp_servers (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL,
    author NVARCHAR(255),
    development_language NVARCHAR(100),
    license NVARCHAR(255),
    download_count BIGINT DEFAULT 0,
    overview NVARCHAR(MAX), -- README.md content
    short_description NVARCHAR(1000),
    server_slug NVARCHAR(255) UNIQUE, -- For glama.ai URL identification
    glama_url NVARCHAR(500), -- Full glama.ai URL
    -- Glama.ai Score Information
    overall_score DECIMAL(5,2), -- Overall score percentage (0.00 to 100.00)
    score_grade NVARCHAR(10), -- Score grade (A+, A, B+, B, C+, C, D, F)
    score_max_points INT DEFAULT 0, -- Maximum possible points
    score_earned_points INT DEFAULT 0, -- Points earned
    score_last_updated DATETIME2,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    scraped_at DATETIME2 DEFAULT GETDATE(),
    is_active BIT DEFAULT 1
);

-- Link Types (npm, github, documentation, etc.)
CREATE TABLE link_types (
    id INT PRIMARY KEY IDENTITY(1,1),
    type_name NVARCHAR(50) NOT NULL UNIQUE, -- npm, github, documentation, website
    icon_class NVARCHAR(100), -- CSS class for icon display
    display_order INT DEFAULT 0
);

-- Server External Links
CREATE TABLE server_links (
    id INT PRIMARY KEY IDENTITY(1,1),
    mcp_server_id INT NOT NULL,
    link_type_id INT NOT NULL,
    url NVARCHAR(1000) NOT NULL,
    link_text NVARCHAR(255),
    is_primary BIT DEFAULT 0, -- Main link for this type
    is_verified BIT DEFAULT 0, -- Link has been verified to work
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    FOREIGN KEY (link_type_id) REFERENCES link_types(id) ON DELETE CASCADE
);

-- Categories for categorization
CREATE TABLE categories (
    id INT PRIMARY KEY IDENTITY(1,1),
    category_name NVARCHAR(100) NOT NULL UNIQUE,
    description NVARCHAR(500),
    is_active BIT DEFAULT 1
);

-- Junction table for MCP Server - Categories relationship
CREATE TABLE server_categories (
    id INT PRIMARY KEY IDENTITY(1,1),
    mcp_server_id INT NOT NULL,
    category_id INT NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    UNIQUE(mcp_server_id, category_id)
);

-- Server Score Criteria table - defines scoring criteria for MCP servers
CREATE TABLE server_score_criteria (
    id INT PRIMARY KEY IDENTITY(1,1),
    criteria_name NVARCHAR(100) NOT NULL UNIQUE,
    criteria_description NVARCHAR(500),
    max_points INT DEFAULT 0,
    is_active BIT DEFAULT 1,
    display_order INT DEFAULT 0,
    created_at DATETIME2 DEFAULT GETDATE()
);

-- Server Scores (normalized scoring data)
CREATE TABLE server_scores (
    id INT PRIMARY KEY IDENTITY(1,1),
    mcp_server_id INT NOT NULL,
    criteria_id INT NOT NULL,
    score_value DECIMAL(5,2) NOT NULL DEFAULT 0,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    FOREIGN KEY (criteria_id) REFERENCES server_score_criteria(id) ON DELETE CASCADE,
    UNIQUE(mcp_server_id, criteria_id)
);

-- Server Configuration Environment Variables
CREATE TABLE server_environment_variables (
    id INT PRIMARY KEY IDENTITY(1,1),
    mcp_server_id INT NOT NULL,
    variable_name NVARCHAR(255) NOT NULL,
    is_required BIT DEFAULT 1,
    description NVARCHAR(MAX),
    default_value NVARCHAR(500),
    data_type NVARCHAR(50), -- string, number, boolean, json
    example_value NVARCHAR(500),
    security_level NVARCHAR(20) DEFAULT 'standard', -- standard, sensitive, secret
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- MCP Prompts (Interactive templates invoked by user choice)
CREATE TABLE mcp_prompts (
    id INT PRIMARY KEY IDENTITY(1,1),
    mcp_server_id INT NOT NULL,
    prompt_name NVARCHAR(255) NOT NULL,
    prompt_description NVARCHAR(MAX),
    prompt_arguments NVARCHAR(MAX), -- JSON schema for arguments
    prompt_category NVARCHAR(100),
    usage_examples NVARCHAR(MAX),
    is_active BIT DEFAULT 1,
    display_order INT DEFAULT 0,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- MCP Resources (Contextual data attached and managed by the client)
CREATE TABLE mcp_resources (
    id INT PRIMARY KEY IDENTITY(1,1),
    mcp_server_id INT NOT NULL,
    resource_name NVARCHAR(255) NOT NULL,
    resource_description NVARCHAR(MAX),
    resource_type NVARCHAR(100), -- file, data, api, service
    access_method NVARCHAR(100), -- uri, subscription, template
    mime_type NVARCHAR(100),
    is_active BIT DEFAULT 1,
    display_order INT DEFAULT 0,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- MCP Tools (Functions exposed by MCP servers)
CREATE TABLE mcp_tools (
    id INT PRIMARY KEY IDENTITY(1,1),
    mcp_server_id INT NOT NULL,
    tool_name NVARCHAR(255) NOT NULL,
    tool_description NVARCHAR(MAX),
    input_schema NVARCHAR(MAX), -- JSON schema for inputs
    output_schema NVARCHAR(MAX), -- JSON schema for outputs
    tool_category NVARCHAR(100),
    usage_examples NVARCHAR(MAX),
    is_active BIT DEFAULT 1,
    display_order INT DEFAULT 0,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- MCP Directory API Endpoints
CREATE TABLE mcp_api_endpoints (
    id INT PRIMARY KEY IDENTITY(1,1),
    mcp_server_id INT NOT NULL,
    endpoint_url NVARCHAR(1000) NOT NULL,
    http_method NVARCHAR(10) DEFAULT 'GET',
    endpoint_description NVARCHAR(500),
    request_headers NVARCHAR(MAX), -- JSON format
    request_parameters NVARCHAR(MAX), -- JSON format
    response_format NVARCHAR(50) DEFAULT 'json',
    is_public BIT DEFAULT 1,
    requires_auth BIT DEFAULT 0,
    rate_limit_info NVARCHAR(255),
    last_tested DATETIME2,
    is_working BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX IX_mcp_servers_name ON mcp_servers(name);
CREATE INDEX IX_mcp_servers_author ON mcp_servers(author);
CREATE INDEX IX_mcp_servers_language ON mcp_servers(development_language);
CREATE INDEX IX_mcp_servers_downloads ON mcp_servers(download_count);
CREATE INDEX IX_mcp_servers_slug ON mcp_servers(server_slug);
CREATE INDEX IX_mcp_servers_active ON mcp_servers(is_active);
CREATE INDEX IX_mcp_servers_scraped_at ON mcp_servers(scraped_at);
CREATE INDEX IX_mcp_servers_score ON mcp_servers(overall_score);
CREATE INDEX IX_mcp_servers_grade ON mcp_servers(score_grade);

CREATE INDEX IX_score_criteria_active ON server_score_criteria(is_active);
CREATE INDEX IX_score_criteria_order ON server_score_criteria(display_order);

CREATE INDEX IX_server_scores_server_id ON server_scores(mcp_server_id);
CREATE INDEX IX_server_scores_criteria_id ON server_scores(criteria_id);
CREATE INDEX IX_server_scores_score_value ON server_scores(score_value);

CREATE INDEX IX_server_links_server_id ON server_links(mcp_server_id);
CREATE INDEX IX_server_links_type ON server_links(link_type_id);
CREATE INDEX IX_server_links_primary ON server_links(is_primary);

CREATE INDEX IX_server_categories_server_id ON server_categories(mcp_server_id);
CREATE INDEX IX_server_categories_category_id ON server_categories(category_id);

CREATE INDEX IX_environment_vars_server_id ON server_environment_variables(mcp_server_id);
CREATE INDEX IX_environment_vars_required ON server_environment_variables(is_required);

CREATE INDEX IX_prompts_server_id ON mcp_prompts(mcp_server_id);
CREATE INDEX IX_prompts_active ON mcp_prompts(is_active);
CREATE INDEX IX_prompts_category ON mcp_prompts(prompt_category);

CREATE INDEX IX_resources_server_id ON mcp_resources(mcp_server_id);
CREATE INDEX IX_resources_type ON mcp_resources(resource_type);
CREATE INDEX IX_resources_active ON mcp_resources(is_active);

CREATE INDEX IX_tools_server_id ON mcp_tools(mcp_server_id);
CREATE INDEX IX_tools_category ON mcp_tools(tool_category);
CREATE INDEX IX_tools_active ON mcp_tools(is_active);

CREATE INDEX IX_api_endpoints_server_id ON mcp_api_endpoints(mcp_server_id);
CREATE INDEX IX_api_endpoints_method ON mcp_api_endpoints(http_method);
CREATE INDEX IX_api_endpoints_working ON mcp_api_endpoints(is_working);

-- Insert common link types
INSERT INTO link_types (type_name, icon_class, display_order) VALUES 
('npm', 'fab fa-npm', 1),
('github', 'fab fa-github', 2),
('documentation', 'fas fa-book', 3),
('website', 'fas fa-external-link-alt', 4),
('gitlab', 'fab fa-gitlab', 5),
('bitbucket', 'fab fa-bitbucket', 6);

-- Insert categories
INSERT INTO categories (category_name) VALUES 
('Art & Culture'),
('RAG Systems'),
('Browser Automation'),
('Web Scraping'),
('Shell Access'),
('Cloud Platforms'),
('Communication'),
('Customer Data Platforms'),
('Databases'),
('Developer Tools'),
('CI/CD & DevOps'),
('File Systems'),
('Knowledge & Memory'),
('Location Services'),
('Marketing'),
('Monitoring'),
('Observability'),
('Vector Databases'),
('Feature Flags'),
('Agent Orchestration'),
('Search'),
('Travel & Transportation'),
('Version Control'),
('Text Summarization'),
('Virtualization'),
('Finance'),
('Blockchain'),
('Web3 & Decentralized Tech'),
('Government Data'),
('Open Data'),
('Cryptocurrency'),
('Research & Data'),
('Social Media'),
('OS Automation'),
('Note Taking'),
('Cloud Storage'),
('Calendar Management'),
('E-commerce & Retail'),
('Health & Wellness'),
('Education & Learning Tools'),
('Entertainment & Media'),
('Home Automation & IoT'),
('Customer Support'),
('Legal & Compliance'),
('Language Translation'),
('Speech Processing'),
('Image & Video Processing'),
('Security'),
('Games & Gamification'),
('Multimedia Processing'),
('Audio Processing'),
('ERP Systems'),
('Code Execution'),
('Code Analysis'),
('Coding Agents'),
('Autonomous Agents'),
('Bioinformatics'),
('Command Line'),
('Data Platforms'),
('Embedded system'),
('Sports'),
('Text-to-Speech'),
('Testing & QA Tools'),
('App Automation'),
('Content Management Systems'),
('API Testing'),
('Documentation Access'),
('Penetration Testing'),
('Project Management'),
('Fitness Tracking'),
('Weather Services'),
('Workplace & Productivity'),
('Real Estate'),
('Biology & Medicine'),
('Aerospace & Astrodynamics');

-- Insert score criteria
INSERT INTO server_score_criteria (criteria_name, criteria_description, max_points, display_order) VALUES 
('has_readme', 'Repository has a README.md file', 10, 1),
('has_license', 'The repository has a LICENSE file', 10, 2),
('has_glama_json', 'Repository has a valid glama.json configuration file', 15, 3),
('server_inspectable', 'Server can be inspected through server inspector', 15, 4),
('has_tools', 'Server has at least one tool defined in schema', 20, 5),
('no_vulnerabilities', 'Server has no known security vulnerabilities', 15, 6),
('claimed_by_author', 'Server is claimed and verified by the original author', 10, 7),
('has_related_servers', 'Server has user-submitted related MCP servers for discoverability', 5, 8);

-- Add some example data for the Playwright MCP server
INSERT INTO mcp_servers (name, author, development_language, license, download_count, overview, server_slug, glama_url,
                        overall_score, score_grade, score_max_points, score_earned_points,
                        has_readme, has_license, has_glama_json, server_inspectable, has_tools, 
                        no_vulnerabilities, claimed_by_author, has_related_servers, score_last_updated) 
VALUES (
    'Playwright MCP',
    'lewisvoncken',
    'TypeScript',
    'Apache 2.0',
    517780,
    'Browser automation tools for web testing and scraping using Playwright framework.',
    'playwright-mcp',
    'https://glama.ai/mcp/servers/playwright-mcp',
    75.00,  -- 75% score
    'B+',   -- Grade
    100,    -- Max points possible
    75,     -- Points earned
    1,      -- Has README
    1,      -- Has LICENSE
    0,      -- No glama.json
    1,      -- Server inspectable
    1,      -- Has tools
    1,      -- No vulnerabilities
    0,      -- Not claimed by author
    0,      -- No related servers
    GETDATE()
);

-- Get the server ID for linking
DECLARE @server_id INT = SCOPE_IDENTITY();

-- Add categories for the Playwright server
INSERT INTO server_categories (mcp_server_id, category_id)
SELECT @server_id, id FROM categories WHERE category_name IN ('Browser Automation', 'RAG Systems', 'Testing & QA Tools');

-- Add links for the Playwright server
INSERT INTO server_links (mcp_server_id, link_type_id, url, link_text, is_primary)
VALUES 
(@server_id, (SELECT id FROM link_types WHERE type_name = 'npm'), 'https://www.npmjs.com/package/@playwright/mcp', 'NPM Package', 1),
(@server_id, (SELECT id FROM link_types WHERE type_name = 'github'), 'https://github.com/lewisvoncken/playwright-mcp', 'GitHub Repository', 1);

-- Add environment variable example
INSERT INTO server_environment_variables (mcp_server_id, variable_name, is_required, description, data_type, security_level)
VALUES 
(@server_id, 'GITHUB_PERSONAL_ACCESS_TOKEN', 1, 'GitHub Personal Access Token with appropriate permissions (repo scope for full control, public_repo for public repositories only)', 'string', 'secret');

-- Add API endpoint example
INSERT INTO mcp_api_endpoints (mcp_server_id, endpoint_url, http_method, endpoint_description, is_public)
VALUES 
(@server_id, 'https://glama.ai/api/mcp/v1/servers/glifxyz/glif-mcp-server', 'GET', 'MCP directory API endpoint for server information', 1);
