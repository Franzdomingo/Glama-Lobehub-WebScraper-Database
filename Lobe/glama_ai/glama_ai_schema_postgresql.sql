-- Glama.ai MCP Server Database Schema - Oracle SQL Version
BEGIN
    EXECUTE 'DROP TABLE server_categories CASCADE CONSTRAINTS';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


BEGIN
    EXECUTE 'DROP TABLE categories CASCADE CONSTRAINTS';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


-- Glama.ai MCP Server Database Schema - Oracle SQL Version
-- Created: September 5, 2025
-- Purpose: Store scraped data from glama.ai MCP server directory
-- Drop tables if they exist (for clean reinstall)
BEGIN
    EXECUTE 'DROP TABLE mcp_api_endpoints CASCADE CONSTRAINTS';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


BEGIN
    EXECUTE 'DROP TABLE mcp_tools CASCADE CONSTRAINTS';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


BEGIN
    EXECUTE 'DROP TABLE mcp_resources CASCADE CONSTRAINTS';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


BEGIN
    EXECUTE 'DROP TABLE mcp_prompts CASCADE CONSTRAINTS';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


BEGIN
    EXECUTE 'DROP TABLE server_environment_variables CASCADE CONSTRAINTS';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


BEGIN
    EXECUTE 'DROP TABLE server_categories CASCADE CONSTRAINTS';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


BEGIN
    EXECUTE 'DROP TABLE server_links CASCADE CONSTRAINTS';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


BEGIN
    EXECUTE 'DROP TABLE categories CASCADE CONSTRAINTS';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


BEGIN
    EXECUTE 'DROP TABLE link_types CASCADE CONSTRAINTS';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


BEGIN
    EXECUTE 'DROP TABLE server_scores CASCADE CONSTRAINTS';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


BEGIN
    EXECUTE 'DROP TABLE mcp_servers CASCADE CONSTRAINTS';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


-- Drop sequences if they exist
BEGIN
    EXECUTE 'DROP SEQUENCE seq_mcp_servers';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


BEGIN
    EXECUTE 'DROP SEQUENCE seq_link_types';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


BEGIN
    EXECUTE 'DROP SEQUENCE seq_server_links';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


BEGIN
    EXECUTE 'DROP SEQUENCE seq_categories';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


BEGIN
    EXECUTE 'DROP SEQUENCE seq_server_categories';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


BEGIN
    EXECUTE 'DROP SEQUENCE seq_server_env_vars';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


BEGIN
    EXECUTE 'DROP SEQUENCE seq_mcp_prompts';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


BEGIN
    EXECUTE 'DROP SEQUENCE seq_mcp_resources';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


BEGIN
    EXECUTE 'DROP SEQUENCE seq_mcp_tools';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


BEGIN
    EXECUTE 'DROP SEQUENCE seq_mcp_api_endpoints';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


BEGIN
    EXECUTE 'DROP SEQUENCE seq_server_scores';

    EXCEPTION WHEN OTHERS THEN NULL
;

END;


-- Create sequences for auto-increment functionality
CREATE SEQUENCE seq_mcp_servers START WITH 1 INCREMENT BY 1 NOCACHE
;

CREATE SEQUENCE seq_server_scores START WITH 1 INCREMENT BY 1 NOCACHE
;

CREATE SEQUENCE seq_link_types START WITH 1 INCREMENT BY 1 NOCACHE
;

CREATE SEQUENCE seq_server_links START WITH 1 INCREMENT BY 1 NOCACHE
;

CREATE SEQUENCE seq_categories START WITH 1 INCREMENT BY 1 NOCACHE
;

CREATE SEQUENCE seq_server_categories START WITH 1 INCREMENT BY 1 NOCACHE
;

CREATE SEQUENCE seq_server_env_vars START WITH 1 INCREMENT BY 1 NOCACHE
;

CREATE SEQUENCE seq_mcp_prompts START WITH 1 INCREMENT BY 1 NOCACHE
;

CREATE SEQUENCE seq_mcp_resources START WITH 1 INCREMENT BY 1 NOCACHE
;

CREATE SEQUENCE seq_mcp_tools START WITH 1 INCREMENT BY 1 NOCACHE
;

CREATE SEQUENCE seq_mcp_api_endpoints START WITH 1 INCREMENT BY 1 NOCACHE
;

-- Main MCP Servers table
CREATE TABLE mcp_servers(
    id bigint PRIMARY KEY,
    name varchar(255) NOT NULL,
    author varchar(255),
    development_language varchar(100),
    license varchar(255),
    download_count bigint DEFAULT 0,
    overview text, -- README.md content
    short_description varchar(1000),
    server_slug varchar(255) UNIQUE, -- For glama.ai URL identification
    glama_url varchar(500), -- Full glama.ai URL
    -- Glama.ai Score Information
    -- Removed all score_ fields
    -- Presence / inspection flags (used by sample inserts)
    -- All scoring criteria moved to server_scores table
    -- score_last_updated removed
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    scraped_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_active smallint DEFAULT 1 CHECK(is_active IN (0, 1))
);

-- Create trigger for auto-increment on mcp_servers
CREATE OR REPLACE TRIGGER trg_mcp_servers_id
    BEFORE INSERT ON mcp_servers
    FOR EACH ROW
BEGIN
    IF NEW.id IS NULL THEN
        SELECT nextval('seq_mcp_servers') INTO STRICT NEW.id;

    END IF
;

END;


-- Server Scores table - stores all scoring criteria and values for each server
CREATE TABLE server_scores(
    id bigint PRIMARY KEY,
    mcp_server_id bigint NOT NULL,
    criteria_name varchar(100) NOT NULL,
    criteria_description varchar(500),
    score_value smallint DEFAULT 0 CHECK(score_value IN (0, 1)), -- 0 or 1 for boolean criteria
    max_points bigint DEFAULT 0,
    display_order bigint DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_server_scores_server FOREIGN KEY(mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT uk_server_scores UNIQUE(mcp_server_id, criteria_name)
);

-- Create trigger for auto-increment on server_scores
CREATE OR REPLACE TRIGGER trg_server_scores_id
    BEFORE INSERT ON server_scores
    FOR EACH ROW
BEGIN
    IF NEW.id IS NULL THEN
        SELECT nextval('seq_server_scores') INTO STRICT NEW.id;

    END IF
;

END;


-- Link Types (npm, github, documentation, etc.)
CREATE TABLE link_types (
    id NUMBER(10) PRIMARY KEY,
    type_name NVARCHAR2(50) NOT NULL UNIQUE, -- npm, github, documentation, website
    icon_class NVARCHAR2(100), -- CSS class for icon display
    display_order NUMBER(10) DEFAULT 0
)
;

-- Create trigger for auto-increment on link_types
CREATE OR REPLACE TRIGGER trg_link_types_id
    BEFORE INSERT ON link_types
    FOR EACH ROW
BEGIN
    IF NEW.id IS NULL THEN
        SELECT nextval('seq_link_types') INTO STRICT NEW.id;

    END IF
;

END;


-- Server External Links
CREATE TABLE server_links(
    id bigint PRIMARY KEY,
    mcp_server_id bigint NOT NULL,
    link_type_id bigint NOT NULL,
    url varchar(1000) NOT NULL,
    link_text varchar(255),
    is_primary smallint DEFAULT 0 CHECK(is_primary IN (0, 1)), -- Main link for this type
    is_verified smallint DEFAULT 0 CHECK(is_verified IN (0, 1)), -- Link has been verified to work
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_server_links_server FOREIGN KEY(mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT fk_server_links_type FOREIGN KEY(link_type_id) REFERENCES link_types(id) ON DELETE CASCADE
);

-- Create trigger for auto-increment on server_links
CREATE OR REPLACE TRIGGER trg_server_links_id
    BEFORE INSERT ON server_links
    FOR EACH ROW
BEGIN
    IF NEW.id IS NULL THEN
        SELECT nextval('seq_server_links') INTO STRICT NEW.id;

    END IF
;

END;


-- Categories for categorization
CREATE TABLE categories (
    id NUMBER(10) PRIMARY KEY,
    category_name NVARCHAR2(100) NOT NULL UNIQUE,
    description NVARCHAR2(500),
    is_active NUMBER(1) DEFAULT 1 CHECK (is_active IN (0, 1))
)
;

-- Create trigger for auto-increment on categories
CREATE OR REPLACE TRIGGER trg_categories_id
    BEFORE INSERT ON categories
    FOR EACH ROW
BEGIN
    IF NEW.id IS NULL THEN
        SELECT nextval('seq_categories') INTO STRICT NEW.id;

    END IF
;

END;


-- Junction table for MCP Server - Categories relationship
CREATE TABLE server_categories(
    id bigint PRIMARY KEY,
    mcp_server_id bigint NOT NULL,
    category_id bigint NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_server_categories_server FOREIGN KEY(mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT fk_server_categories_category FOREIGN KEY(category_id) REFERENCES categories(id) ON DELETE CASCADE,
    CONSTRAINT uk_server_categories UNIQUE(mcp_server_id, category_id)
);

-- Create trigger for auto-increment on server_categories
CREATE OR REPLACE TRIGGER trg_server_categories_id
    BEFORE INSERT ON server_categories
    FOR EACH ROW
BEGIN
    IF NEW.id IS NULL THEN
        SELECT nextval('seq_server_categories') INTO STRICT NEW.id;

    END IF
;

END;


-- Server Configuration Environment Variables
CREATE TABLE server_environment_variables (
    variable_name NVARCHAR2(255) PRIMARY KEY, -- Name
    is_required NUMBER(1) DEFAULT 1 CHECK (is_required IN (0, 1)), -- Required
    description CLOB -- Description
    --default_value NVARCHAR2(500) -- Default (commented out for now)
)
;

-- MCP Prompts (Interactive templates invoked by user choice)
CREATE TABLE mcp_prompts(
    id bigint PRIMARY KEY,
    mcp_server_id bigint NOT NULL,
    prompt_name varchar(255) NOT NULL,
    prompt_description text,
    CONSTRAINT fk_prompts_server FOREIGN KEY(mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Create trigger for auto-increment on mcp_prompts
CREATE OR REPLACE TRIGGER trg_mcp_prompts_id
    BEFORE INSERT ON mcp_prompts
    FOR EACH ROW
BEGIN
    IF NEW.id IS NULL THEN
        SELECT nextval('seq_mcp_prompts') INTO STRICT NEW.id;

    END IF
;

END;


-- MCP Resources (Contextual data attached and managed by the client)
CREATE TABLE mcp_resources(
    id bigint PRIMARY KEY,
    mcp_server_id bigint NOT NULL,
    resource_name varchar(255) NOT NULL,
    resource_description text,
    CONSTRAINT fk_resources_server FOREIGN KEY(mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Create trigger for auto-increment on mcp_resources
CREATE OR REPLACE TRIGGER trg_mcp_resources_id
    BEFORE INSERT ON mcp_resources
    FOR EACH ROW
BEGIN
    IF NEW.id IS NULL THEN
        SELECT nextval('seq_mcp_resources') INTO STRICT NEW.id;

    END IF
;

END;


-- MCP Tools (Functions exposed by MCP servers)
CREATE TABLE mcp_tools(
    id bigint PRIMARY KEY,
    mcp_server_id bigint NOT NULL,
    tool_name varchar(255) NOT NULL,
    tool_description text,
    input_schema text, -- JSON schema for inputs
    output_schema text, -- JSON schema for outputs
    tool_category varchar(100),
    usage_examples text,
    is_active smallint DEFAULT 1 CHECK(is_active IN (0, 1)),
    display_order bigint DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tools_server FOREIGN KEY(mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Create trigger for auto-increment on mcp_tools
CREATE OR REPLACE TRIGGER trg_mcp_tools_id
    BEFORE INSERT ON mcp_tools
    FOR EACH ROW
BEGIN
    IF NEW.id IS NULL THEN
        SELECT nextval('seq_mcp_tools') INTO STRICT NEW.id;

    END IF
;

END;


-- MCP Directory API Endpoints
CREATE TABLE mcp_api_endpoints(
    id bigint PRIMARY KEY,
    mcp_server_id bigint NOT NULL,
    endpoint_url varchar(1000) NOT NULL,
    http_method varchar(10) DEFAULT 'GET',
    endpoint_description varchar(500),
    request_headers text, -- JSON format
    request_parameters text, -- JSON format
    response_format varchar(50) DEFAULT 'json',
    is_public smallint DEFAULT 1 CHECK(is_public IN (0, 1)),
    requires_auth smallint DEFAULT 0 CHECK(requires_auth IN (0, 1)),
    rate_limit_info varchar(255),
    last_tested TIMESTAMP WITH TIME ZONE,
    is_working smallint DEFAULT 1 CHECK(is_working IN (0, 1)),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_api_endpoints_server FOREIGN KEY(mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Create trigger for auto-increment on mcp_api_endpoints
CREATE OR REPLACE TRIGGER trg_mcp_api_endpoints_id
    BEFORE INSERT ON mcp_api_endpoints
    FOR EACH ROW
BEGIN
    IF NEW.id IS NULL THEN
        SELECT nextval('seq_mcp_api_endpoints') INTO STRICT NEW.id;

    END IF
;

END;


-- Create indexes for better performance
CREATE INDEX idx_mcp_servers_name ON mcp_servers(name);

CREATE INDEX idx_mcp_servers_author ON mcp_servers(author);

CREATE INDEX idx_mcp_servers_language ON mcp_servers(development_language);

CREATE INDEX idx_mcp_servers_downloads ON mcp_servers(download_count);

CREATE INDEX idx_mcp_servers_slug ON mcp_servers(server_slug);

CREATE INDEX idx_mcp_servers_active ON mcp_servers(is_active);

CREATE INDEX idx_mcp_servers_scraped_at ON mcp_servers(scraped_at);

CREATE INDEX idx_server_links_server_id ON server_links(mcp_server_id);

CREATE INDEX idx_server_links_type ON server_links(link_type_id);

CREATE INDEX idx_server_links_primary ON server_links(is_primary);

CREATE INDEX idx_server_categories_server_id ON server_categories(mcp_server_id);

CREATE INDEX idx_server_categories_category_id ON server_categories(category_id);

-- Removed index on mcp_server_id because environment variables are now global definitions
CREATE INDEX idx_server_scores_server_id ON server_scores(mcp_server_id);

CREATE INDEX idx_server_scores_criteria_id ON server_scores(criteria_id);

CREATE INDEX idx_server_scores_score_value ON server_scores(score_value);

CREATE INDEX idx_environment_vars_required ON server_environment_variables(is_required);

CREATE INDEX idx_prompts_server_id ON mcp_prompts(mcp_server_id);

CREATE INDEX idx_resources_server_id ON mcp_resources(mcp_server_id);

CREATE INDEX idx_tools_server_id ON mcp_tools(mcp_server_id);

CREATE INDEX idx_tools_category ON mcp_tools(tool_category);

CREATE INDEX idx_tools_active ON mcp_tools(is_active);

CREATE INDEX idx_api_endpoints_server_id ON mcp_api_endpoints(mcp_server_id);

CREATE INDEX idx_api_endpoints_method ON mcp_api_endpoints(http_method);

CREATE INDEX idx_api_endpoints_working ON mcp_api_endpoints(is_working);

-- Insert common link types
INSERT INTO link_types(type_name, icon_class, display_order) VALUES ('npm', 'fab fa-npm', 1);

INSERT INTO link_types(type_name, icon_class, display_order) VALUES ('github', 'fab fa-github', 2);

INSERT INTO link_types(type_name, icon_class, display_order) VALUES ('documentation', 'fas fa-book', 3);

INSERT INTO link_types(type_name, icon_class, display_order) VALUES ('website', 'fas fa-external-link-alt', 4);

INSERT INTO link_types(type_name, icon_class, display_order) VALUES ('gitlab', 'fab fa-gitlab', 5);

INSERT INTO link_types(type_name, icon_class, display_order) VALUES ('bitbucket', 'fab fa-bitbucket', 6);

-- Insert categories
INSERT INTO categories(category_name) VALUES ('Art & Culture');

INSERT INTO categories(category_name) VALUES ('RAG Systems');

INSERT INTO categories(category_name) VALUES ('Browser Automation');

INSERT INTO categories(category_name) VALUES ('Web Scraping');

INSERT INTO categories(category_name) VALUES ('Shell Access');

INSERT INTO categories(category_name) VALUES ('Cloud Platforms');

INSERT INTO categories(category_name) VALUES ('Communication');

INSERT INTO categories(category_name) VALUES ('Customer Data Platforms');

INSERT INTO categories(category_name) VALUES ('Databases');

INSERT INTO categories(category_name) VALUES ('Developer Tools');

INSERT INTO categories(category_name) VALUES ('CI/CD & DevOps');

INSERT INTO categories(category_name) VALUES ('File Systems');

INSERT INTO categories(category_name) VALUES ('Knowledge & Memory');

INSERT INTO categories(category_name) VALUES ('Location Services');

INSERT INTO categories(category_name) VALUES ('Marketing');

INSERT INTO categories(category_name) VALUES ('Monitoring');

INSERT INTO categories(category_name) VALUES ('Observability');

INSERT INTO categories(category_name) VALUES ('Vector Databases');

INSERT INTO categories(category_name) VALUES ('Feature Flags');

INSERT INTO categories(category_name) VALUES ('Agent Orchestration');

INSERT INTO categories(category_name) VALUES ('Search');

INSERT INTO categories(category_name) VALUES ('Travel & Transportation');

INSERT INTO categories(category_name) VALUES ('Version Control');

INSERT INTO categories(category_name) VALUES ('Text Summarization');

INSERT INTO categories(category_name) VALUES ('Virtualization');

INSERT INTO categories(category_name) VALUES ('Finance');

INSERT INTO categories(category_name) VALUES ('Blockchain');

INSERT INTO categories(category_name) VALUES ('Web3 & Decentralized Tech');

INSERT INTO categories(category_name) VALUES ('Government Data');

INSERT INTO categories(category_name) VALUES ('Open Data');

INSERT INTO categories(category_name) VALUES ('Cryptocurrency');

INSERT INTO categories(category_name) VALUES ('Research & Data');

INSERT INTO categories(category_name) VALUES ('Social Media');

INSERT INTO categories(category_name) VALUES ('OS Automation');

INSERT INTO categories(category_name) VALUES ('Note Taking');

INSERT INTO categories(category_name) VALUES ('Cloud Storage');

INSERT INTO categories(category_name) VALUES ('Calendar Management');

INSERT INTO categories(category_name) VALUES ('E-commerce & Retail');

INSERT INTO categories(category_name) VALUES ('Health & Wellness');

INSERT INTO categories(category_name) VALUES ('Education & Learning Tools');

INSERT INTO categories(category_name) VALUES ('Entertainment & Media');

INSERT INTO categories(category_name) VALUES ('Home Automation & IoT');

INSERT INTO categories(category_name) VALUES ('Customer Support');

INSERT INTO categories(category_name) VALUES ('Legal & Compliance');

INSERT INTO categories(category_name) VALUES ('Language Translation');

INSERT INTO categories(category_name) VALUES ('Speech Processing');

INSERT INTO categories(category_name) VALUES ('Image & Video Processing');

INSERT INTO categories(category_name) VALUES ('Security');

INSERT INTO categories(category_name) VALUES ('Games & Gamification');

INSERT INTO categories(category_name) VALUES ('Multimedia Processing');

INSERT INTO categories(category_name) VALUES ('Audio Processing');

INSERT INTO categories(category_name) VALUES ('ERP Systems');

INSERT INTO categories(category_name) VALUES ('Code Execution');

INSERT INTO categories(category_name) VALUES ('Code Analysis');

INSERT INTO categories(category_name) VALUES ('Coding Agents');

INSERT INTO categories(category_name) VALUES ('Autonomous Agents');

INSERT INTO categories(category_name) VALUES ('Bioinformatics');

INSERT INTO categories(category_name) VALUES ('Command Line');

INSERT INTO categories(category_name) VALUES ('Data Platforms');

INSERT INTO categories(category_name) VALUES ('Embedded system');

INSERT INTO categories(category_name) VALUES ('Sports');

INSERT INTO categories(category_name) VALUES ('Text-to-Speech');

INSERT INTO categories(category_name) VALUES ('Testing & QA Tools');

INSERT INTO categories(category_name) VALUES ('App Automation');

INSERT INTO categories(category_name) VALUES ('Content Management Systems');

INSERT INTO categories(category_name) VALUES ('API Testing');

INSERT INTO categories(category_name) VALUES ('Documentation Access');

INSERT INTO categories(category_name) VALUES ('Penetration Testing');

INSERT INTO categories(category_name) VALUES ('Project Management');

INSERT INTO categories(category_name) VALUES ('Fitness Tracking');

INSERT INTO categories(category_name) VALUES ('Weather Services');

INSERT INTO categories(category_name) VALUES ('Workplace & Productivity');

INSERT INTO categories(category_name) VALUES ('Real Estate');

INSERT INTO categories(category_name) VALUES ('Biology & Medicine');

INSERT INTO categories(category_name) VALUES ('Aerospace & Astrodynamics');

-- Insert score criteria
-- Commit the changes
-- Add categories for the Playwright server
DECLARE
    v_server_id bigint;

    v_category_id NUMBER
;

BEGIN
    -- Get the server ID
    SELECT id INTO STRICT v_server_id FROM mcp_servers WHERE name = 'Playwright MCP';

    -- Add Browser Automation category
    SELECT id INTO STRICT v_category_id FROM categories WHERE category_name = 'Browser Automation';

    INSERT INTO server_categories(mcp_server_id, category_id) VALUES (v_server_id, v_category_id);

    -- Add RAG Systems category
    SELECT id INTO STRICT v_category_id FROM categories WHERE category_name = 'RAG Systems';

    INSERT INTO server_categories(mcp_server_id, category_id) VALUES (v_server_id, v_category_id);

    -- Add Testing & QA Tools category
    SELECT id INTO STRICT v_category_id FROM categories WHERE category_name = 'Testing & QA Tools';

    INSERT INTO server_categories(mcp_server_id, category_id) VALUES (v_server_id, v_category_id);

END;


-- Add links for the Playwright server
DECLARE
    v_server_id NUMBER
;

    v_link_type_id NUMBER
;

BEGIN
    -- Get the server ID
    SELECT id INTO STRICT v_server_id FROM mcp_servers WHERE name = 'Playwright MCP';

    -- Add npm link
    SELECT id INTO STRICT v_link_type_id FROM link_types WHERE type_name = 'npm';

    INSERT INTO server_links(mcp_server_id, link_type_id, url, link_text, is_primary)
    VALUES (v_server_id, v_link_type_id, 'https://www.npmjs.com/package/@playwright/mcp', 'NPM Package', 1);

    -- Add github link
    SELECT id INTO STRICT v_link_type_id FROM link_types WHERE type_name = 'github';

    INSERT INTO server_links(mcp_server_id, link_type_id, url, link_text, is_primary)
    VALUES (v_server_id, v_link_type_id, 'https://github.com/lewisvoncken/playwright-mcp', 'GitHub Repository', 1);

END;


-- Add environment variable example
DECLARE
    v_server_id NUMBER
;

BEGIN
    -- Get the server ID
    SELECT id INTO STRICT v_server_id FROM mcp_servers WHERE name = 'Playwright MCP';

    -- Add as a global environment variable definition (no per-server mapping in this table)
    INSERT INTO server_environment_variables(variable_name, is_required, description)
    VALUES ('GITHUB_PERSONAL_ACCESS_TOKEN', 1,
           'GitHub Personal Access Token with appropriate permissions (repo scope for full control, public_repo for public repositories only)');

END;


-- Example environment variable (simplified for new table shape)
INSERT INTO server_environment_variables(variable_name, is_required, description) VALUES (
    'GITHUB_PERSONAL_ACCESS_TOKEN',
    1,
    'GitHub Personal Access Token with appropriate permissions (repo scope for full control, public_repo for public repositories only)'
);

-- Add API endpoint example
DECLARE
    v_server_id NUMBER
;

BEGIN
    -- Get the server ID
    SELECT id INTO STRICT v_server_id FROM mcp_servers WHERE name = 'Playwright MCP';

    INSERT INTO mcp_api_endpoints(mcp_server_id, endpoint_url, http_method, endpoint_description, is_public)
    VALUES (v_server_id, 'https://glama.ai/api/mcp/v1/servers/glifxyz/glif-mcp-server', 'GET',
           'MCP directory API endpoint for server information', 1);

END;


-- Final commit
COMMIT
;

-- Display success message
SELECT 'Oracle schema for Glama.ai MCP servers created successfully!' AS status;
