-- Glama.ai MCP Server Database Schema - PostgreSQL Version
-- Created: September 5, 2025
-- Purpose: Store scraped data from glama.ai MCP server directory

-- Drop tables if they exist (for clean reinstall)
DROP TABLE IF EXISTS server_score_criteria CASCADE;
DROP TABLE IF EXISTS mcp_api_endpoints CASCADE;
DROP TABLE IF EXISTS mcp_tools CASCADE;
DROP TABLE IF EXISTS mcp_resources CASCADE;
DROP TABLE IF EXISTS mcp_prompts CASCADE;
DROP TABLE IF EXISTS server_environment_variables CASCADE;
DROP TABLE IF EXISTS server_categories CASCADE;
DROP TABLE IF EXISTS server_links CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS link_types CASCADE;
DROP TABLE IF EXISTS mcp_servers CASCADE;

-- Main MCP Servers table
CREATE TABLE mcp_servers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    author VARCHAR(255),
    development_language VARCHAR(100),
    license VARCHAR(255),
    download_count BIGINT DEFAULT 0,
    overview TEXT, -- README.md content
    short_description VARCHAR(1000),
    server_slug VARCHAR(255) UNIQUE, -- For glama.ai URL identification
    glama_url VARCHAR(500), -- Full glama.ai URL
    -- Glama.ai Score Information
    overall_score DECIMAL(5,2), -- Overall score percentage (0.00 to 100.00)
    score_grade VARCHAR(10), -- Score grade (A+, A, B+, B, C+, C, D, F)
    score_max_points INTEGER DEFAULT 0, -- Maximum possible points
    score_earned_points INTEGER DEFAULT 0, -- Points earned
    has_readme BOOLEAN DEFAULT FALSE,
    has_license BOOLEAN DEFAULT FALSE,
    has_glama_json BOOLEAN DEFAULT FALSE,
    server_inspectable BOOLEAN DEFAULT FALSE,
    has_tools BOOLEAN DEFAULT FALSE,
    no_vulnerabilities BOOLEAN DEFAULT FALSE,
    claimed_by_author BOOLEAN DEFAULT FALSE,
    has_related_servers BOOLEAN DEFAULT FALSE,
    score_last_updated TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    scraped_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Link Types (npm, github, documentation, etc.)
CREATE TABLE link_types (
    id SERIAL PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE, -- npm, github, documentation, website
    icon_class VARCHAR(100), -- CSS class for icon display
    display_order INTEGER DEFAULT 0
);

-- Server External Links
CREATE TABLE server_links (
    id SERIAL PRIMARY KEY,
    mcp_server_id INTEGER NOT NULL,
    link_type_id INTEGER NOT NULL,
    url VARCHAR(1000) NOT NULL,
    link_text VARCHAR(255),
    is_primary BOOLEAN DEFAULT FALSE, -- Main link for this type
    is_verified BOOLEAN DEFAULT FALSE, -- Link has been verified to work
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    FOREIGN KEY (link_type_id) REFERENCES link_types(id) ON DELETE CASCADE
);

-- Categories for categorization
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE
);

-- Junction table for MCP Server - Categories relationship
CREATE TABLE server_categories (
    id SERIAL PRIMARY KEY,
    mcp_server_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    UNIQUE(mcp_server_id, category_id)
);

-- Server Score Criteria table - defines scoring criteria for MCP servers
CREATE TABLE server_score_criteria (
    id SERIAL PRIMARY KEY,
    criteria_name VARCHAR(100) NOT NULL UNIQUE,
    criteria_description VARCHAR(500),
    max_points INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Server Configuration Environment Variables
CREATE TABLE server_environment_variables (
    id SERIAL PRIMARY KEY,
    mcp_server_id INTEGER NOT NULL,
    variable_name VARCHAR(255) NOT NULL,
    is_required BOOLEAN DEFAULT TRUE,
    description TEXT,
    default_value VARCHAR(500),
    data_type VARCHAR(50), -- string, number, boolean, json
    example_value VARCHAR(500),
    security_level VARCHAR(20) DEFAULT 'standard', -- standard, sensitive, secret
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- MCP Prompts (Interactive templates invoked by user choice)
CREATE TABLE mcp_prompts (
    id SERIAL PRIMARY KEY,
    mcp_server_id INTEGER NOT NULL,
    prompt_name VARCHAR(255) NOT NULL,
    prompt_description TEXT,
    prompt_arguments TEXT, -- JSON schema for arguments
    prompt_category VARCHAR(100),
    usage_examples TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- MCP Resources (Contextual data attached and managed by the client)
CREATE TABLE mcp_resources (
    id SERIAL PRIMARY KEY,
    mcp_server_id INTEGER NOT NULL,
    resource_name VARCHAR(255) NOT NULL,
    resource_description TEXT,
    resource_type VARCHAR(100), -- file, data, api, service
    access_method VARCHAR(100), -- uri, subscription, template
    mime_type VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- MCP Tools (Functions exposed by MCP servers)
CREATE TABLE mcp_tools (
    id SERIAL PRIMARY KEY,
    mcp_server_id INTEGER NOT NULL,
    tool_name VARCHAR(255) NOT NULL,
    tool_description TEXT,
    input_schema TEXT, -- JSON schema for inputs
    output_schema TEXT, -- JSON schema for outputs
    tool_category VARCHAR(100),
    usage_examples TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- MCP Directory API Endpoints
CREATE TABLE mcp_api_endpoints (
    id SERIAL PRIMARY KEY,
    mcp_server_id INTEGER NOT NULL,
    endpoint_url VARCHAR(1000) NOT NULL,
    http_method VARCHAR(10) DEFAULT 'GET',
    endpoint_description VARCHAR(500),
    request_headers TEXT, -- JSON format
    request_parameters TEXT, -- JSON format
    response_format VARCHAR(50) DEFAULT 'json',
    is_public BOOLEAN DEFAULT TRUE,
    requires_auth BOOLEAN DEFAULT FALSE,
    rate_limit_info VARCHAR(255),
    last_tested TIMESTAMP WITH TIME ZONE,
    is_working BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX idx_mcp_servers_name ON mcp_servers(name);
CREATE INDEX idx_mcp_servers_author ON mcp_servers(author);
CREATE INDEX idx_mcp_servers_language ON mcp_servers(development_language);
CREATE INDEX idx_mcp_servers_downloads ON mcp_servers(download_count);
CREATE INDEX idx_mcp_servers_slug ON mcp_servers(server_slug);
CREATE INDEX idx_mcp_servers_active ON mcp_servers(is_active);
CREATE INDEX idx_mcp_servers_scraped_at ON mcp_servers(scraped_at);
CREATE INDEX idx_mcp_servers_score ON mcp_servers(overall_score);
CREATE INDEX idx_mcp_servers_grade ON mcp_servers(score_grade);
CREATE INDEX idx_mcp_servers_has_readme ON mcp_servers(has_readme);
CREATE INDEX idx_mcp_servers_has_license ON mcp_servers(has_license);
CREATE INDEX idx_mcp_servers_claimed ON mcp_servers(claimed_by_author);

CREATE INDEX idx_score_criteria_active ON server_score_criteria(is_active);
CREATE INDEX idx_score_criteria_order ON server_score_criteria(display_order);

CREATE INDEX idx_server_links_server_id ON server_links(mcp_server_id);
CREATE INDEX idx_server_links_type ON server_links(link_type_id);
CREATE INDEX idx_server_links_primary ON server_links(is_primary);

CREATE INDEX idx_server_categories_server_id ON server_categories(mcp_server_id);
CREATE INDEX idx_server_categories_category_id ON server_categories(category_id);

CREATE INDEX idx_environment_vars_server_id ON server_environment_variables(mcp_server_id);
CREATE INDEX idx_environment_vars_required ON server_environment_variables(is_required);

CREATE INDEX idx_prompts_server_id ON mcp_prompts(mcp_server_id);
CREATE INDEX idx_prompts_active ON mcp_prompts(is_active);
CREATE INDEX idx_prompts_category ON mcp_prompts(prompt_category);

CREATE INDEX idx_resources_server_id ON mcp_resources(mcp_server_id);
CREATE INDEX idx_resources_type ON mcp_resources(resource_type);
CREATE INDEX idx_resources_active ON mcp_resources(is_active);

CREATE INDEX idx_tools_server_id ON mcp_tools(mcp_server_id);
CREATE INDEX idx_tools_category ON mcp_tools(tool_category);
CREATE INDEX idx_tools_active ON mcp_tools(is_active);

CREATE INDEX idx_api_endpoints_server_id ON mcp_api_endpoints(mcp_server_id);
CREATE INDEX idx_api_endpoints_method ON mcp_api_endpoints(http_method);
CREATE INDEX idx_api_endpoints_working ON mcp_api_endpoints(is_working);

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
    TRUE,   -- Has README
    TRUE,   -- Has LICENSE
    FALSE,  -- No glama.json
    TRUE,   -- Server inspectable
    TRUE,   -- Has tools
    TRUE,   -- No vulnerabilities
    FALSE,  -- Not claimed by author
    FALSE,  -- No related servers
    CURRENT_TIMESTAMP
);

-- Add categories for the Playwright server
WITH server_id AS (SELECT id FROM mcp_servers WHERE name = 'Playwright MCP'),
     category_ids AS (SELECT id FROM categories WHERE category_name IN ('Browser Automation', 'RAG Systems', 'Testing & QA Tools'))
INSERT INTO server_categories (mcp_server_id, category_id)
SELECT server_id.id, category_ids.id
FROM server_id CROSS JOIN category_ids;

-- Add links for the Playwright server
WITH server_id AS (SELECT id FROM mcp_servers WHERE name = 'Playwright MCP')
INSERT INTO server_links (mcp_server_id, link_type_id, url, link_text, is_primary)
SELECT 
    server_id.id,
    link_types.id,
    CASE 
        WHEN link_types.type_name = 'npm' THEN 'https://www.npmjs.com/package/@playwright/mcp'
        WHEN link_types.type_name = 'github' THEN 'https://github.com/lewisvoncken/playwright-mcp'
    END,
    CASE 
        WHEN link_types.type_name = 'npm' THEN 'NPM Package'
        WHEN link_types.type_name = 'github' THEN 'GitHub Repository'
    END,
    TRUE
FROM server_id CROSS JOIN link_types
WHERE link_types.type_name IN ('npm', 'github');

-- Add environment variable example
WITH server_id AS (SELECT id FROM mcp_servers WHERE name = 'Playwright MCP')
INSERT INTO server_environment_variables (mcp_server_id, variable_name, is_required, description, data_type, security_level)
SELECT 
    server_id.id,
    'GITHUB_PERSONAL_ACCESS_TOKEN',
    TRUE,
    'GitHub Personal Access Token with appropriate permissions (repo scope for full control, public_repo for public repositories only)',
    'string',
    'secret'
FROM server_id;

-- Add API endpoint example
WITH server_id AS (SELECT id FROM mcp_servers WHERE name = 'Playwright MCP')
INSERT INTO mcp_api_endpoints (mcp_server_id, endpoint_url, http_method, endpoint_description, is_public)
SELECT 
    server_id.id,
    'https://glama.ai/api/mcp/v1/servers/glifxyz/glif-mcp-server',
    'GET',
    'MCP directory API endpoint for server information',
    TRUE
FROM server_id;
