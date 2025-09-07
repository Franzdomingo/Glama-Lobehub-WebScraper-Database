-- Created by Franz Phillip G. Domingo 
-- Created: September 5, 2025
-- Last Updated: September 8, 2025
-- Purpose: Store scraped data from glama.ai MCP server directory

-- Drop tables if they exist (for clean reinstall)
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
    EXECUTE IMMEDIATE 'DROP TABLE mcp_links CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE categories CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE mcp_scores CASCADE CONSTRAINTS';
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
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_mcp_servers';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_mcp_links';
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
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_mcp_scores';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE mcp_related_servers CASCADE CONSTRAINTS';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_mcp_related_servers';
    EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- Create sequences for auto-increment functionality
CREATE SEQUENCE seq_mcp_servers START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_mcp_scores START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_mcp_related_servers START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_mcp_links START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_categories START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_server_categories START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_server_env_vars START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_mcp_prompts START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_mcp_resources START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_mcp_tools START WITH 1 INCREMENT BY 1 NOCACHE;

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
    -- Note: server_slug is a unique URL-friendly identifier (e.g., 'my-server-name')
    --       glama_url is the complete web address (e.g., 'https://glama.ai/servers/my-server-name')
    -- Removed all score_ fields
    -- Presence / inspection flags (used by sample inserts)
    -- All scoring criteria moved to server_scores table
    -- score_last_updated removed
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    scraped_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    mcp_directory_api NVARCHAR2(1000), -- MCP directory API endpoint URL
    github_star_count NUMBER(10) DEFAULT 0, -- GitHub star count
    is_active NUMBER(1) DEFAULT 1 CHECK (is_active IN (0, 1)) -- 1=active, 0=inactive; controls server visibility/soft delete
);

-- Score Summary Table
CREATE TABLE score_summary (
    id NUMBER(10) PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    security CHAR(1) CHECK (security IN ('A', 'F')),
    license CHAR(1) CHECK (license IN ('A', 'F')),
    quality CHAR(1) CHECK (quality IN ('A', 'F')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_score_summary_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT uk_score_summary_server UNIQUE(mcp_server_id)
);

-- Trigger for auto-increment on score_summary
CREATE SEQUENCE seq_score_summary START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE OR REPLACE TRIGGER trg_score_summary_id
    BEFORE INSERT ON score_summary
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT seq_score_summary.NEXTVAL INTO :NEW.id FROM dual;
    END IF;
END;
/

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

CREATE TABLE mcp_scores (
    id NUMBER(10) PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    score_summary_id NUMBER(10),
    criteria_name NVARCHAR2(100) NOT NULL,
    criteria_description NVARCHAR2(500),
    score_value NUMBER(1) DEFAULT 0 CHECK (score_value IN (0, 1)), -- 0 or 1 for boolean criteria
    max_points NUMBER(10) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_mcp_scores_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT fk_mcp_scores_summary FOREIGN KEY (score_summary_id) REFERENCES score_summary(id) ON DELETE SET NULL,
    CONSTRAINT uk_mcp_scores UNIQUE(mcp_server_id, criteria_name)
);

-- Create trigger for auto-increment on mcp_scores
CREATE OR REPLACE TRIGGER trg_mcp_scores_id
    BEFORE INSERT ON mcp_scores
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT seq_mcp_scores.NEXTVAL INTO :NEW.id FROM dual;
    END IF;
END;
/

-- MCP Related Servers table - stores relationships between servers
CREATE TABLE mcp_related_servers (
    id NUMBER(10) PRIMARY KEY,
    source_server_id NUMBER(10) NOT NULL,
    related_server_id NUMBER(10) NOT NULL,
    relationship_type NVARCHAR2(50) NOT NULL CHECK (relationship_type IN ('Semantically Related Servers', 'User-submitted Alternatives')),
    relationship_strength NUMBER(3,2) DEFAULT 0.00 CHECK (relationship_strength >= 0.00 AND relationship_strength <= 1.00), -- 0.00 to 1.00 scale
    description NVARCHAR2(1000), -- Optional description of the relationship
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by NVARCHAR2(255), -- User or system that created this relationship
    is_active NUMBER(1) DEFAULT 1 CHECK (is_active IN (0, 1)), -- 1=active, 0=inactive
    CONSTRAINT fk_related_servers_source FOREIGN KEY (source_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT fk_related_servers_related FOREIGN KEY (related_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT uk_related_servers UNIQUE(source_server_id, related_server_id, relationship_type),
    CONSTRAINT chk_no_self_reference CHECK (source_server_id != related_server_id)
);

-- Create trigger for auto-increment on mcp_related_servers
CREATE OR REPLACE TRIGGER trg_mcp_related_servers_id
    BEFORE INSERT ON mcp_related_servers
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT seq_mcp_related_servers.NEXTVAL INTO :NEW.id FROM dual;
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

-- MCP External Links
CREATE TABLE mcp_links (
    id NUMBER(10) PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    link_type NVARCHAR2(50) NOT NULL,
    url NVARCHAR2(1000) NOT NULL,
    is_primary NUMBER(1) DEFAULT 0 CHECK (is_primary IN (0, 1)), -- Main link for this type
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_mcp_links_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Create trigger for auto-increment on mcp_links
CREATE OR REPLACE TRIGGER trg_mcp_links_id
    BEFORE INSERT ON mcp_links
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT seq_mcp_links.NEXTVAL INTO :NEW.id FROM dual;
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
    variable_name NVARCHAR2(255) PRIMARY KEY, -- Name
    is_required NUMBER(1) DEFAULT 1 CHECK (is_required IN (0, 1)), -- Required
    description CLOB -- Description
);

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



CREATE TABLE mcp_reviews (
    id NUMBER(10) PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    review_content CLOB, -- Full review text (CLOB for flexibility)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_reviews_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

CREATE OR REPLACE TRIGGER trg_mcp_reviews_id
    BEFORE INSERT ON mcp_reviews
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT seq_mcp_servers.NEXTVAL INTO :NEW.id FROM dual; -- Reuse server sequence for simplicity
    END IF;
END;
/

-- MCP Endpoints table - stores endpoint information for each MCP server
-- Using CLOB for endpoint_content since endpoint data is unstructured or not available on glama.ai
CREATE TABLE mcp_endpoints (
    id NUMBER(10) PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    endpoint_content CLOB, -- All endpoint info as CLOB
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_endpoints_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Create trigger for auto-increment on mcp_endpoints
CREATE OR REPLACE TRIGGER trg_mcp_endpoints_id
    BEFORE INSERT ON mcp_endpoints
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT seq_mcp_servers.NEXTVAL INTO :NEW.id FROM dual; -- Reuse server sequence for simplicity
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

CREATE INDEX idx_mcp_links_server_id ON mcp_links(mcp_server_id);
CREATE INDEX idx_mcp_links_type ON mcp_links(link_type);
CREATE INDEX idx_mcp_links_primary ON mcp_links(is_primary);

CREATE INDEX idx_server_categories_server_id ON server_categories(mcp_server_id);
CREATE INDEX idx_server_categories_category_id ON server_categories(category_id);

CREATE INDEX idx_mcp_scores_server_id ON mcp_scores(mcp_server_id);
CREATE INDEX idx_mcp_scores_score_value ON mcp_scores(score_value);

CREATE INDEX idx_mcp_related_servers_source ON mcp_related_servers(source_server_id);
CREATE INDEX idx_mcp_related_servers_related ON mcp_related_servers(related_server_id);
CREATE INDEX idx_mcp_related_servers_type ON mcp_related_servers(relationship_type);
CREATE INDEX idx_mcp_related_servers_strength ON mcp_related_servers(relationship_strength);
CREATE INDEX idx_mcp_related_servers_active ON mcp_related_servers(is_active);

CREATE INDEX idx_environment_vars_required ON server_environment_variables(is_required);

CREATE INDEX idx_prompts_server_id ON mcp_prompts(mcp_server_id);

CREATE INDEX idx_resources_server_id ON mcp_resources(mcp_server_id);

CREATE INDEX idx_tools_server_id ON mcp_tools(mcp_server_id);
CREATE INDEX idx_tools_category ON mcp_tools(tool_category);
CREATE INDEX idx_tools_active ON mcp_tools(is_active);

-- See sample_data_insertion_oracle.sql for category inserts

-- Final commit
COMMIT;

-- Display success message
SELECT 'Oracle schema for Glama.ai MCP servers created successfully!' AS status FROM dual;
