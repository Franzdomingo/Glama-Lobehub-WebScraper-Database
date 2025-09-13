-- GLAMA.AI MCP Server - CREATE TABLE Statements Only
-- Created by Franz Phillip G. Domingo
-- Purpose: Table creation statements for ERD visualization

-- Main MCP Servers table
CREATE TABLE mcp_servers (
    id NUMBER(10) DEFAULT seq_mcp_servers.NEXTVAL PRIMARY KEY,
    name NVARCHAR2(255) NOT NULL,
    author NVARCHAR2(255),
    development_language NVARCHAR2(100),
    license NVARCHAR2(255),
    download_count NUMBER(19) DEFAULT 0 CHECK (download_count >= 0),
    overview CLOB, -- README.md content
    short_description NVARCHAR2(1000),
    server_slug NVARCHAR2(255) NOT NULL UNIQUE, -- For glama.ai URL identification
    glama_url NVARCHAR2(500), -- Full glama.ai URL
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    scraped_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    mcp_directory_api NVARCHAR2(1000), -- MCP directory API endpoint URL
    github_star_count NUMBER(10) DEFAULT 0 CHECK (github_star_count >= 0), -- GitHub star count
    is_active NUMBER(1) DEFAULT 1 NOT NULL CHECK (is_active IN (0, 1)), -- 1=active, 0=inactive; controls server visibility/soft delete
    CONSTRAINT chk_mcp_servers_name_length CHECK (LENGTH(TRIM(name)) > 0)
);

-- Score Summary Table
CREATE TABLE score_summary (
    id NUMBER(10) DEFAULT seq_score_summary.NEXTVAL PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    security CHAR(1) CHECK (security IN ('A', 'F')),
    license CHAR(1) CHECK (license IN ('A', 'F')),
    quality CHAR(1) CHECK (quality IN ('A', 'F')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_score_summary_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT uk_score_summary_server UNIQUE(mcp_server_id)
);

CREATE TABLE mcp_scores (
    id NUMBER(10) DEFAULT seq_mcp_scores.NEXTVAL PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    score_summary_id NUMBER(10),
    criteria_name NVARCHAR2(100) NOT NULL,
    criteria_description NVARCHAR2(500),
    score_value NUMBER(1) DEFAULT 0 CHECK (score_value IN (0, 1)), -- 0 or 1 for boolean criteria
    max_points NUMBER(10) DEFAULT 0 CHECK (max_points >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_mcp_scores_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT fk_mcp_scores_summary FOREIGN KEY (score_summary_id) REFERENCES score_summary(id) ON DELETE SET NULL,
    CONSTRAINT uk_mcp_scores UNIQUE(mcp_server_id, criteria_name),
    CONSTRAINT chk_mcp_scores_criteria_name CHECK (LENGTH(TRIM(criteria_name)) > 0)
);

-- MCP Related Servers table - stores relationships between servers
CREATE TABLE mcp_related_servers (
    id NUMBER(10) DEFAULT seq_mcp_related_servers.NEXTVAL PRIMARY KEY,
    source_server_id NUMBER(10) NOT NULL,
    related_server_id NUMBER(10) NOT NULL,
    relationship_type NVARCHAR2(50) NOT NULL CHECK (relationship_type IN ('Semantically Related Servers', 'User-submitted Alternatives')),
    description NVARCHAR2(1000), -- Optional description of the relationship
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by NVARCHAR2(255), -- User or system that created this relationship
    is_active NUMBER(1) DEFAULT 1 NOT NULL CHECK (is_active IN (0, 1)), -- 1=active, 0=inactive
    CONSTRAINT fk_related_servers_source FOREIGN KEY (source_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT fk_related_servers_related FOREIGN KEY (related_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT uk_related_servers UNIQUE(source_server_id, related_server_id, relationship_type),
    CONSTRAINT chk_no_self_reference CHECK (source_server_id != related_server_id)
);

-- Categories for categorization
CREATE TABLE categories (
    id NUMBER(10) DEFAULT seq_categories.NEXTVAL PRIMARY KEY,
    category_name NVARCHAR2(100) NOT NULL UNIQUE,
    description NVARCHAR2(500),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_active NUMBER(1) DEFAULT 1 NOT NULL CHECK (is_active IN (0, 1)),
    CONSTRAINT chk_categories_name_length CHECK (LENGTH(TRIM(category_name)) > 0)
);

-- MCP External Links
CREATE TABLE mcp_links (
    id NUMBER(10) DEFAULT seq_mcp_links.NEXTVAL PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    link_type NVARCHAR2(50) NOT NULL,
    url NVARCHAR2(1000) NOT NULL,
    is_primary NUMBER(1) DEFAULT 0 CHECK (is_primary IN (0, 1)), -- Main link for this type
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_mcp_links_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT chk_mcp_links_url_length CHECK (LENGTH(TRIM(url)) > 0),
    CONSTRAINT chk_mcp_links_type_length CHECK (LENGTH(TRIM(link_type)) > 0)
);

-- Junction table for MCP Server - Categories relationship
CREATE TABLE server_categories (
    id NUMBER(10) DEFAULT seq_server_categories.NEXTVAL PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    category_id NUMBER(10) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_server_categories_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT fk_server_categories_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    CONSTRAINT uk_server_categories UNIQUE(mcp_server_id, category_id)
);

-- Server Configuration Environment Variables
CREATE TABLE server_environment_variables (
    id NUMBER(10) DEFAULT seq_server_environment_variables.NEXTVAL PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    variable_name NVARCHAR2(255) NOT NULL, -- Name
    is_required NUMBER(1) DEFAULT 1 CHECK (is_required IN (0, 1)), -- Required
    description CLOB, -- Description
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_server_env_vars_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT uk_server_env_vars UNIQUE(mcp_server_id, variable_name),
    CONSTRAINT chk_server_env_vars_name CHECK (LENGTH(TRIM(variable_name)) > 0)
);

-- MCP Prompts (Interactive templates invoked by user choice)
CREATE TABLE mcp_prompts (
    id NUMBER(10) DEFAULT seq_mcp_prompts.NEXTVAL PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    prompt_name NVARCHAR2(255) NOT NULL,
    prompt_description CLOB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_prompts_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT chk_mcp_prompts_name CHECK (LENGTH(TRIM(prompt_name)) > 0)
);

-- MCP Resources (Contextual data attached and managed by the client)
CREATE TABLE mcp_resources (
    id NUMBER(10) DEFAULT seq_mcp_resources.NEXTVAL PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    resource_name NVARCHAR2(255) NOT NULL,
    resource_description CLOB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_resources_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT chk_mcp_resources_name CHECK (LENGTH(TRIM(resource_name)) > 0)
);

-- MCP Tools (Functions exposed by MCP servers)
CREATE TABLE mcp_tools (
    id NUMBER(10) DEFAULT seq_mcp_tools.NEXTVAL PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    tool_name NVARCHAR2(255) NOT NULL,
    tool_description CLOB,
    input_schema_json CLOB, -- JSON schema for inputs
    tool_category NVARCHAR2(100),
    usage_examples CLOB,
    is_active NUMBER(1) DEFAULT 1 NOT NULL CHECK (is_active IN (0, 1)),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_tools_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT chk_mcp_tools_name CHECK (LENGTH(TRIM(tool_name)) > 0)
);

CREATE TABLE mcp_reviews (
    id NUMBER(10) DEFAULT seq_mcp_reviews.NEXTVAL PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    review_content CLOB, -- Full review text (CLOB for flexibility)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_reviews_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- MCP Endpoints table - stores endpoint information for each MCP server
CREATE TABLE mcp_endpoints (
    id NUMBER(10) DEFAULT seq_mcp_endpoints.NEXTVAL PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    endpoint_content CLOB, -- All endpoint info as CLOB
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_endpoints_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- MCP Input Schema table - stores individual input parameters for MCP tools
CREATE TABLE mcp_input_schema (
    id NUMBER(10) DEFAULT seq_mcp_input_schema.NEXTVAL PRIMARY KEY,
    mcp_tool_id NUMBER(10) NOT NULL,
    parameter_name NVARCHAR2(255) NOT NULL, -- Name
    is_required NUMBER(1) DEFAULT 1 CHECK (is_required IN (0, 1)), -- Required (1=true, 0=false)
    description CLOB, -- Description
    default_value NVARCHAR2(1000), -- Default value
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_input_schema_tool FOREIGN KEY (mcp_tool_id) REFERENCES mcp_tools(id) ON DELETE CASCADE,
    CONSTRAINT uk_input_schema_tool_param UNIQUE(mcp_tool_id, parameter_name),
    CONSTRAINT chk_input_schema_name CHECK (LENGTH(TRIM(parameter_name)) > 0)
);