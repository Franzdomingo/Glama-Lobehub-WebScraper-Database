-- Glama.ai MCP Server Database Schema - Oracle SQL Version
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE server_categories CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE categories CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Glama.ai MCP Server Database Schema - Oracle SQL Version
-- Created: September 5, 2025
-- Purpose: Store scraped data from glama.ai MCP server directory

-- Drop tables if they exist (for clean reinstall)
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE mcp_api_endpoints CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE mcp_tools CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE mcp_resources CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE mcp_prompts CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE server_environment_variables CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE server_categories CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE server_links CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE categories CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE link_types CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE server_scores CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE server_score_criteria CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE mcp_servers CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Drop sequences if they exist
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_server_score_criteria';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_mcp_servers';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_link_types';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_server_links';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_categories';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_server_categories';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_server_env_vars';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_mcp_prompts';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_mcp_resources';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_mcp_tools';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_mcp_api_endpoints';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_server_scores';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Create sequences for auto-increment functionality
CREATE SEQUENCE seq_mcp_servers START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_server_score_criteria START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_server_scores START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_link_types START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_server_links START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_categories START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_server_categories START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_server_env_vars START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_mcp_prompts START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_mcp_resources START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_mcp_tools START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_mcp_api_endpoints START WITH 1 INCREMENT BY 1 NOCACHE;

-- Main MCP Servers table
CREATE TABLE mcp_servers (
    id NUMBER(10) PRIMARY KEY,
    name NVARCHAR2(255) NOT NULL,
    author NVARCHAR2(255),
    development_language NVARCHAR2(100),
    license NVARCHAR2(255),
    download_count NUMBER(19) DEFAULT 0,
    overview CLOB, -- README.md content
    short_description NVARCHAR2(1000),
    server_slug NVARCHAR2(255) UNIQUE, -- For glama.ai URL identification
    glama_url NVARCHAR2(500), -- Full glama.ai URL
    -- Glama.ai Score Information
    overall_score NUMBER(5,2), -- Overall score percentage (0.00 to 100.00)
    score_grade NVARCHAR2(10), -- Score grade (A+, A, B+, B, C+, C, D, F)
    score_max_points NUMBER(10) DEFAULT 0, -- Maximum possible points
    score_earned_points NUMBER(10) DEFAULT 0, -- Points earned
    score_last_updated TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    scraped_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_active NUMBER(1) DEFAULT 1 CHECK (is_active IN (0, 1))
);

-- Create trigger for auto-increment on mcp_servers
CREATE OR REPLACE TRIGGER trg_mcp_servers_id
    BEFORE INSERT ON mcp_servers
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT seq_mcp_servers.NEXTVAL INTO :NEW.id FROM dual;
    END IF;
END;
/

-- Server Score Criteria table - defines scoring criteria for MCP servers
CREATE TABLE server_score_criteria (
    id NUMBER(10) PRIMARY KEY,
    criteria_name NVARCHAR2(100) NOT NULL UNIQUE,
    criteria_description NVARCHAR2(500),
    max_points NUMBER(10) DEFAULT 0,
    is_active NUMBER(1) DEFAULT 1 CHECK (is_active IN (0, 1)),
    display_order NUMBER(10) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create trigger for auto-increment on server_score_criteria
CREATE OR REPLACE TRIGGER trg_server_score_criteria_id
    BEFORE INSERT ON server_score_criteria
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT seq_server_score_criteria.NEXTVAL INTO :NEW.id FROM dual;
    END IF;
END;
/

-- Server Scores table - stores individual score values for each server
CREATE TABLE server_scores (
    id NUMBER(10) PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    criteria_id NUMBER(10) NOT NULL,
    score_value NUMBER(1) DEFAULT 0 CHECK (score_value IN (0, 1)), -- 0 or 1 for boolean criteria
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_server_scores_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT fk_server_scores_criteria FOREIGN KEY (criteria_id) REFERENCES server_score_criteria(id) ON DELETE CASCADE,
    CONSTRAINT uk_server_scores UNIQUE(mcp_server_id, criteria_id)
);

-- Create trigger for auto-increment on server_scores
CREATE OR REPLACE TRIGGER trg_server_scores_id
    BEFORE INSERT ON server_scores
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT seq_server_scores.NEXTVAL INTO :NEW.id FROM dual;
    END IF;
END;
/

-- Link Types (npm, github, documentation, etc.)
CREATE TABLE link_types (
    id NUMBER(10) PRIMARY KEY,
    type_name NVARCHAR2(50) NOT NULL UNIQUE, -- npm, github, documentation, website
    icon_class NVARCHAR2(100), -- CSS class for icon display
    display_order NUMBER(10) DEFAULT 0
);

-- Create trigger for auto-increment on link_types
CREATE OR REPLACE TRIGGER trg_link_types_id
    BEFORE INSERT ON link_types
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT seq_link_types.NEXTVAL INTO :NEW.id FROM dual;
    END IF;
END;
/

-- Server External Links
CREATE TABLE server_links (
    id NUMBER(10) PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    link_type_id NUMBER(10) NOT NULL,
    url NVARCHAR2(1000) NOT NULL,
    link_text NVARCHAR2(255),
    is_primary NUMBER(1) DEFAULT 0 CHECK (is_primary IN (0, 1)), -- Main link for this type
    is_verified NUMBER(1) DEFAULT 0 CHECK (is_verified IN (0, 1)), -- Link has been verified to work
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_server_links_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT fk_server_links_type FOREIGN KEY (link_type_id) REFERENCES link_types(id) ON DELETE CASCADE
);

-- Create trigger for auto-increment on server_links
CREATE OR REPLACE TRIGGER trg_server_links_id
    BEFORE INSERT ON server_links
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT seq_server_links.NEXTVAL INTO :NEW.id FROM dual;
    END IF;
END;
/

-- Categories for categorization
CREATE TABLE categories (
    id NUMBER(10) PRIMARY KEY,
    category_name NVARCHAR2(100) NOT NULL UNIQUE,
    description NVARCHAR2(500),
    is_active NUMBER(1) DEFAULT 1 CHECK (is_active IN (0, 1))
);

-- Create trigger for auto-increment on categories
CREATE OR REPLACE TRIGGER trg_categories_id
    BEFORE INSERT ON categories
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT seq_categories.NEXTVAL INTO :NEW.id FROM dual;
    END IF;
END;
/

-- Junction table for MCP Server - Categories relationship
CREATE TABLE server_categories (
    id NUMBER(10) PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    category_id NUMBER(10) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_server_categories_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT fk_server_categories_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    CONSTRAINT uk_server_categories UNIQUE(mcp_server_id, category_id)
);

-- Create trigger for auto-increment on server_categories
CREATE OR REPLACE TRIGGER trg_server_categories_id
    BEFORE INSERT ON server_categories
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT seq_server_categories.NEXTVAL INTO :NEW.id FROM dual;
    END IF;
END;
/

-- Server Configuration Environment Variables
CREATE TABLE server_environment_variables (
    id NUMBER(10) PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    variable_name NVARCHAR2(255) NOT NULL,
    is_required NUMBER(1) DEFAULT 1 CHECK (is_required IN (0, 1)),
    description CLOB,
    default_value NVARCHAR2(500),
    data_type NVARCHAR2(50), -- string, number, boolean, json
    example_value NVARCHAR2(500),
    security_level NVARCHAR2(20) DEFAULT 'standard', -- standard, sensitive, secret
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_env_vars_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Create trigger for auto-increment on server_environment_variables
CREATE OR REPLACE TRIGGER trg_server_env_vars_id
    BEFORE INSERT ON server_environment_variables
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT seq_server_env_vars.NEXTVAL INTO :NEW.id FROM dual;
    END IF;
END;
/

-- MCP Prompts (Interactive templates invoked by user choice)
CREATE TABLE mcp_prompts (
    id NUMBER(10) PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    prompt_name NVARCHAR2(255) NOT NULL,
    prompt_description CLOB,
    CONSTRAINT fk_prompts_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Create trigger for auto-increment on mcp_prompts
CREATE OR REPLACE TRIGGER trg_mcp_prompts_id
    BEFORE INSERT ON mcp_prompts
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT seq_mcp_prompts.NEXTVAL INTO :NEW.id FROM dual;
    END IF;
END;
/

-- MCP Resources (Contextual data attached and managed by the client)
CREATE TABLE mcp_resources (
    id NUMBER(10) PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    resource_name NVARCHAR2(255) NOT NULL,
    resource_description CLOB,
    CONSTRAINT fk_resources_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Create trigger for auto-increment on mcp_resources
CREATE OR REPLACE TRIGGER trg_mcp_resources_id
    BEFORE INSERT ON mcp_resources
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT seq_mcp_resources.NEXTVAL INTO :NEW.id FROM dual;
    END IF;
END;
/

-- MCP Tools (Functions exposed by MCP servers)
CREATE TABLE mcp_tools (
    id NUMBER(10) PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    tool_name NVARCHAR2(255) NOT NULL,
    tool_description CLOB,
    input_schema CLOB, -- JSON schema for inputs
    output_schema CLOB, -- JSON schema for outputs
    tool_category NVARCHAR2(100),
    usage_examples CLOB,
    is_active NUMBER(1) DEFAULT 1 CHECK (is_active IN (0, 1)),
    display_order NUMBER(10) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tools_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Create trigger for auto-increment on mcp_tools
CREATE OR REPLACE TRIGGER trg_mcp_tools_id
    BEFORE INSERT ON mcp_tools
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT seq_mcp_tools.NEXTVAL INTO :NEW.id FROM dual;
    END IF;
END;
/

-- MCP Directory API Endpoints
CREATE TABLE mcp_api_endpoints (
    id NUMBER(10) PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    endpoint_url NVARCHAR2(1000) NOT NULL,
    http_method NVARCHAR2(10) DEFAULT 'GET',
    endpoint_description NVARCHAR2(500),
    request_headers CLOB, -- JSON format
    request_parameters CLOB, -- JSON format
    response_format NVARCHAR2(50) DEFAULT 'json',
    is_public NUMBER(1) DEFAULT 1 CHECK (is_public IN (0, 1)),
    requires_auth NUMBER(1) DEFAULT 0 CHECK (requires_auth IN (0, 1)),
    rate_limit_info NVARCHAR2(255),
    last_tested TIMESTAMP WITH TIME ZONE,
    is_working NUMBER(1) DEFAULT 1 CHECK (is_working IN (0, 1)),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_api_endpoints_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Create trigger for auto-increment on mcp_api_endpoints
CREATE OR REPLACE TRIGGER trg_mcp_api_endpoints_id
    BEFORE INSERT ON mcp_api_endpoints
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT seq_mcp_api_endpoints.NEXTVAL INTO :NEW.id FROM dual;
    END IF;
END;
/

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

CREATE INDEX idx_score_criteria_active ON server_score_criteria(is_active);
CREATE INDEX idx_score_criteria_order ON server_score_criteria(display_order);

CREATE INDEX idx_server_links_server_id ON server_links(mcp_server_id);
CREATE INDEX idx_server_links_type ON server_links(link_type_id);
CREATE INDEX idx_server_links_primary ON server_links(is_primary);

CREATE INDEX idx_server_categories_server_id ON server_categories(mcp_server_id);
CREATE INDEX idx_server_categories_category_id ON server_categories(category_id);

CREATE INDEX idx_environment_vars_server_id ON server_environment_variables(mcp_server_id);

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
INSERT INTO link_types (type_name, icon_class, display_order) VALUES 
('npm', 'fab fa-npm', 1);
INSERT INTO link_types (type_name, icon_class, display_order) VALUES 
('github', 'fab fa-github', 2);
INSERT INTO link_types (type_name, icon_class, display_order) VALUES 
('documentation', 'fas fa-book', 3);
INSERT INTO link_types (type_name, icon_class, display_order) VALUES 
('website', 'fas fa-external-link-alt', 4);
INSERT INTO link_types (type_name, icon_class, display_order) VALUES 
('gitlab', 'fab fa-gitlab', 5);
INSERT INTO link_types (type_name, icon_class, display_order) VALUES 
('bitbucket', 'fab fa-bitbucket', 6);

-- Insert categories
INSERT INTO categories (category_name) VALUES ('Art & Culture');
INSERT INTO categories (category_name) VALUES ('RAG Systems');
INSERT INTO categories (category_name) VALUES ('Browser Automation');
INSERT INTO categories (category_name) VALUES ('Web Scraping');
INSERT INTO categories (category_name) VALUES ('Shell Access');
INSERT INTO categories (category_name) VALUES ('Cloud Platforms');
INSERT INTO categories (category_name) VALUES ('Communication');
INSERT INTO categories (category_name) VALUES ('Customer Data Platforms');
INSERT INTO categories (category_name) VALUES ('Databases');
INSERT INTO categories (category_name) VALUES ('Developer Tools');
INSERT INTO categories (category_name) VALUES ('CI/CD & DevOps');
INSERT INTO categories (category_name) VALUES ('File Systems');
INSERT INTO categories (category_name) VALUES ('Knowledge & Memory');
INSERT INTO categories (category_name) VALUES ('Location Services');
INSERT INTO categories (category_name) VALUES ('Marketing');
INSERT INTO categories (category_name) VALUES ('Monitoring');
INSERT INTO categories (category_name) VALUES ('Observability');
INSERT INTO categories (category_name) VALUES ('Vector Databases');
INSERT INTO categories (category_name) VALUES ('Feature Flags');
INSERT INTO categories (category_name) VALUES ('Agent Orchestration');
INSERT INTO categories (category_name) VALUES ('Search');
INSERT INTO categories (category_name) VALUES ('Travel & Transportation');
INSERT INTO categories (category_name) VALUES ('Version Control');
INSERT INTO categories (category_name) VALUES ('Text Summarization');
INSERT INTO categories (category_name) VALUES ('Virtualization');
INSERT INTO categories (category_name) VALUES ('Finance');
INSERT INTO categories (category_name) VALUES ('Blockchain');
INSERT INTO categories (category_name) VALUES ('Web3 & Decentralized Tech');
INSERT INTO categories (category_name) VALUES ('Government Data');
INSERT INTO categories (category_name) VALUES ('Open Data');
INSERT INTO categories (category_name) VALUES ('Cryptocurrency');
INSERT INTO categories (category_name) VALUES ('Research & Data');
INSERT INTO categories (category_name) VALUES ('Social Media');
INSERT INTO categories (category_name) VALUES ('OS Automation');
INSERT INTO categories (category_name) VALUES ('Note Taking');
INSERT INTO categories (category_name) VALUES ('Cloud Storage');
INSERT INTO categories (category_name) VALUES ('Calendar Management');
INSERT INTO categories (category_name) VALUES ('E-commerce & Retail');
INSERT INTO categories (category_name) VALUES ('Health & Wellness');
INSERT INTO categories (category_name) VALUES ('Education & Learning Tools');
INSERT INTO categories (category_name) VALUES ('Entertainment & Media');
INSERT INTO categories (category_name) VALUES ('Home Automation & IoT');
INSERT INTO categories (category_name) VALUES ('Customer Support');
INSERT INTO categories (category_name) VALUES ('Legal & Compliance');
INSERT INTO categories (category_name) VALUES ('Language Translation');
INSERT INTO categories (category_name) VALUES ('Speech Processing');
INSERT INTO categories (category_name) VALUES ('Image & Video Processing');
INSERT INTO categories (category_name) VALUES ('Security');
INSERT INTO categories (category_name) VALUES ('Games & Gamification');
INSERT INTO categories (category_name) VALUES ('Multimedia Processing');
INSERT INTO categories (category_name) VALUES ('Audio Processing');
INSERT INTO categories (category_name) VALUES ('ERP Systems');
INSERT INTO categories (category_name) VALUES ('Code Execution');
INSERT INTO categories (category_name) VALUES ('Code Analysis');
INSERT INTO categories (category_name) VALUES ('Coding Agents');
INSERT INTO categories (category_name) VALUES ('Autonomous Agents');
INSERT INTO categories (category_name) VALUES ('Bioinformatics');
INSERT INTO categories (category_name) VALUES ('Command Line');
INSERT INTO categories (category_name) VALUES ('Data Platforms');
INSERT INTO categories (category_name) VALUES ('Embedded system');
INSERT INTO categories (category_name) VALUES ('Sports');
INSERT INTO categories (category_name) VALUES ('Text-to-Speech');
INSERT INTO categories (category_name) VALUES ('Testing & QA Tools');
INSERT INTO categories (category_name) VALUES ('App Automation');
INSERT INTO categories (category_name) VALUES ('Content Management Systems');
INSERT INTO categories (category_name) VALUES ('API Testing');
INSERT INTO categories (category_name) VALUES ('Documentation Access');
INSERT INTO categories (category_name) VALUES ('Penetration Testing');
INSERT INTO categories (category_name) VALUES ('Project Management');
INSERT INTO categories (category_name) VALUES ('Fitness Tracking');
INSERT INTO categories (category_name) VALUES ('Weather Services');
INSERT INTO categories (category_name) VALUES ('Workplace & Productivity');
INSERT INTO categories (category_name) VALUES ('Real Estate');
INSERT INTO categories (category_name) VALUES ('Biology & Medicine');
INSERT INTO categories (category_name) VALUES ('Aerospace & Astrodynamics');

-- Insert score criteria
INSERT INTO server_score_criteria (criteria_name, criteria_description, max_points, display_order) VALUES 
('has_readme', 'Repository has a README.md file', 10, 1);
INSERT INTO server_score_criteria (criteria_name, criteria_description, max_points, display_order) VALUES 
('has_license', 'The repository has a LICENSE file', 10, 2);
INSERT INTO server_score_criteria (criteria_name, criteria_description, max_points, display_order) VALUES 
('has_glama_json', 'Repository has a valid glama.json configuration file', 15, 3);
INSERT INTO server_score_criteria (criteria_name, criteria_description, max_points, display_order) VALUES 
('server_inspectable', 'Server can be inspected through server inspector', 15, 4);
INSERT INTO server_score_criteria (criteria_name, criteria_description, max_points, display_order) VALUES 
('has_tools', 'Server has at least one tool defined in schema', 20, 5);
INSERT INTO server_score_criteria (criteria_name, criteria_description, max_points, display_order) VALUES 
('no_vulnerabilities', 'Server has no known security vulnerabilities', 15, 6);
INSERT INTO server_score_criteria (criteria_name, criteria_description, max_points, display_order) VALUES 
('claimed_by_author', 'Server is claimed and verified by the original author', 10, 7);
INSERT INTO server_score_criteria (criteria_name, criteria_description, max_points, display_order) VALUES 
('has_related_servers', 'Server has user-submitted related MCP servers for discoverability', 5, 8);

-- Commit the changes
COMMIT;

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
    CURRENT_TIMESTAMP
);

-- Add categories for the Playwright server
DECLARE
    v_server_id NUMBER;
    v_category_id NUMBER;
BEGIN
    -- Get the server ID
    SELECT id INTO v_server_id FROM mcp_servers WHERE name = 'Playwright MCP';
    
    -- Add Browser Automation category
    SELECT id INTO v_category_id FROM categories WHERE category_name = 'Browser Automation';
    INSERT INTO server_categories (mcp_server_id, category_id) VALUES (v_server_id, v_category_id);
    
    -- Add RAG Systems category
    SELECT id INTO v_category_id FROM categories WHERE category_name = 'RAG Systems';
    INSERT INTO server_categories (mcp_server_id, category_id) VALUES (v_server_id, v_category_id);
    
    -- Add Testing & QA Tools category
    SELECT id INTO v_category_id FROM categories WHERE category_name = 'Testing & QA Tools';
    INSERT INTO server_categories (mcp_server_id, category_id) VALUES (v_server_id, v_category_id);
END;
/

-- Add links for the Playwright server
DECLARE
    v_server_id NUMBER;
    v_link_type_id NUMBER;
BEGIN
    -- Get the server ID
    SELECT id INTO v_server_id FROM mcp_servers WHERE name = 'Playwright MCP';
    
    -- Add npm link
    SELECT id INTO v_link_type_id FROM link_types WHERE type_name = 'npm';
    INSERT INTO server_links (mcp_server_id, link_type_id, url, link_text, is_primary)
    VALUES (v_server_id, v_link_type_id, 'https://www.npmjs.com/package/@playwright/mcp', 'NPM Package', 1);
    
    -- Add github link
    SELECT id INTO v_link_type_id FROM link_types WHERE type_name = 'github';
    INSERT INTO server_links (mcp_server_id, link_type_id, url, link_text, is_primary)
    VALUES (v_server_id, v_link_type_id, 'https://github.com/lewisvoncken/playwright-mcp', 'GitHub Repository', 1);
END;
/

-- Add environment variable example
DECLARE
    v_server_id NUMBER;
BEGIN
    -- Get the server ID
    SELECT id INTO v_server_id FROM mcp_servers WHERE name = 'Playwright MCP';
    
    INSERT INTO server_environment_variables (mcp_server_id, variable_name, is_required, description, data_type, security_level)
    VALUES (v_server_id, 'GITHUB_PERSONAL_ACCESS_TOKEN', 1, 
           'GitHub Personal Access Token with appropriate permissions (repo scope for full control, public_repo for public repositories only)', 
           'string', 'secret');
END;
/

-- Add API endpoint example
DECLARE
    v_server_id NUMBER;
BEGIN
    -- Get the server ID
    SELECT id INTO v_server_id FROM mcp_servers WHERE name = 'Playwright MCP';
    
    INSERT INTO mcp_api_endpoints (mcp_server_id, endpoint_url, http_method, endpoint_description, is_public)
    VALUES (v_server_id, 'https://glama.ai/api/mcp/v1/servers/glifxyz/glif-mcp-server', 'GET', 
           'MCP directory API endpoint for server information', 1);
END;
/

-- Final commit
COMMIT;

-- Display success message
SELECT 'Oracle schema for Glama.ai MCP servers created successfully!' AS status FROM dual;
