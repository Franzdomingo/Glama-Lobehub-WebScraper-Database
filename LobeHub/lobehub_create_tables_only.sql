-- LobeHub MCP Server - CREATE TABLE Statements Only
-- Oracle SQL Schema for MCP Server Database Table
-- Follows Oracle SQL standards with proper data types and constraints

CREATE TABLE mcp_server (
    id NUMBER(10) DEFAULT seq_mcp_server.NEXTVAL PRIMARY KEY,
    name NVARCHAR2(255) NOT NULL,
    author NVARCHAR2(255),
    development_language NVARCHAR2(100),
    license NVARCHAR2(255),
    download_count NUMBER(19) DEFAULT 0 CHECK (download_count >= 0),
    overview CLOB, -- README.md content
    short_description NVARCHAR2(1000),
    server_slug NVARCHAR2(255) NOT NULL UNIQUE,
    lobehub_url NVARCHAR2(500),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_active NUMBER(1) DEFAULT 1 NOT NULL CHECK (is_active IN (0, 1)),
    CONSTRAINT chk_mcp_server_name_length CHECK (LENGTH(TRIM(name)) > 0)
);

-- Links table for MCP server external links
CREATE TABLE mcp_server_links (
    id NUMBER(10) DEFAULT seq_mcp_server_links.NEXTVAL PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    link_type NVARCHAR2(100),
    is_primary NUMBER(1) DEFAULT 0 CHECK (is_primary IN (0, 1)),
    url NVARCHAR2(1000) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_mcp_server_links FOREIGN KEY (mcp_server_id) REFERENCES mcp_server(id)
);

-- Dependencies table for MCP server requirements
CREATE TABLE mcp_server_dependencies (
    id NUMBER(10) DEFAULT seq_mcp_server_dependencies.NEXTVAL PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    dependency_type NVARCHAR2(100), -- 'system', 'npm', 'python', etc.
    dependency_name NVARCHAR2(255) NOT NULL,
    version_requirement NVARCHAR2(100), -- '>=18', '^1.0.0', etc.
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_mcp_server_dependencies FOREIGN KEY (mcp_server_id) REFERENCES mcp_server(id)
);

-- Installation methods table for different platforms
CREATE TABLE mcp_server_installation_methods (
    id NUMBER(10) DEFAULT seq_mcp_server_installation_methods.NEXTVAL PRIMARY KEY,
    dependency_id NUMBER(10) NOT NULL,
    platform NVARCHAR2(50) NOT NULL, -- 'macos', 'windows', 'linux_debian', 'manual'
    installation_command NVARCHAR2(1000),
    installation_url NVARCHAR2(500),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_installation_dependency FOREIGN KEY (dependency_id) REFERENCES mcp_server_dependencies(id)
);

-- Tools table for MCP server available tools
CREATE TABLE mcp_server_tools (
    id NUMBER(10) DEFAULT seq_mcp_server_tools.NEXTVAL PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    tool_name NVARCHAR2(255) NOT NULL,
    tool_description NVARCHAR2(1000),
    is_active NUMBER(1) DEFAULT 1 NOT NULL CHECK (is_active IN (0, 1)),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_mcp_server_tools FOREIGN KEY (mcp_server_id) REFERENCES mcp_server(id)
);

-- Tool parameters table for tool input specifications
CREATE TABLE mcp_server_tool_parameters (
    id NUMBER(10) DEFAULT seq_mcp_server_tool_parameters.NEXTVAL PRIMARY KEY,
    tool_id NUMBER(10) NOT NULL,
    parameter_name NVARCHAR2(255) NOT NULL,
    parameter_type NVARCHAR2(100),
    is_required NUMBER(1) DEFAULT 0 CHECK (is_required IN (0, 1)),
    parameter_description NVARCHAR2(1000),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_tool_parameters FOREIGN KEY (tool_id) REFERENCES mcp_server_tools(id)
);

-- Prompts table for MCP server configuration prompts
CREATE TABLE mcp_server_prompts (
    id NUMBER(10) DEFAULT seq_mcp_server_prompts.NEXTVAL PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    prompt_name NVARCHAR2(255) NOT NULL,
    prompt_description NVARCHAR2(1000),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_mcp_server_prompts FOREIGN KEY (mcp_server_id) REFERENCES mcp_server(id)
);

-- Prompt parameters table for prompt configuration options
CREATE TABLE mcp_server_prompt_parameters (
    id NUMBER(10) DEFAULT seq_mcp_server_prompt_parameters.NEXTVAL PRIMARY KEY,
    prompt_id NUMBER(10) NOT NULL,
    parameter_name NVARCHAR2(255) NOT NULL,
    is_required NUMBER(1) DEFAULT 0 CHECK (is_required IN (0, 1)),
    parameter_description NVARCHAR2(1000),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_prompt_parameters FOREIGN KEY (prompt_id) REFERENCES mcp_server_prompts(id)
);

-- Resources table for MCP server attached resources
CREATE TABLE mcp_server_resources (
    id NUMBER(10) DEFAULT seq_mcp_server_resources.NEXTVAL PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    resource_name NVARCHAR2(255) NOT NULL,
    mime_type NVARCHAR2(255),
    uri NVARCHAR2(1000) NOT NULL,
    resource_description NVARCHAR2(1000),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_mcp_server_resources FOREIGN KEY (mcp_server_id) REFERENCES mcp_server(id)
);

-- Score table for MCP server quality assessment
CREATE TABLE mcp_server_scores (
    id NUMBER(10) DEFAULT seq_mcp_server_scores.NEXTVAL PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    overall_score NUMBER(3) NOT NULL, -- 0-100
    grade NVARCHAR2(2) NOT NULL, -- A, B, C, D, F
    grade_percentage NUMBER(5,2) NOT NULL, -- 0.00-100.00
    validation_status NVARCHAR2(50) DEFAULT 'Validated',
    installation_methods_count NUMBER(3) DEFAULT 0,
    tools_count NUMBER(3) DEFAULT 0,
    resources_count NUMBER(3) DEFAULT 0,
    has_readme NUMBER(1) DEFAULT 0 CHECK (has_readme IN (0, 1)), -- 0 or 1
    has_license NUMBER(1) DEFAULT 0 CHECK (has_license IN (0, 1)), -- 0 or 1
    has_prompts NUMBER(1) DEFAULT 0 CHECK (has_prompts IN (0, 1)), -- 0 or 1
    is_claimed_by_owner NUMBER(1) DEFAULT 0 CHECK (is_claimed_by_owner IN (0, 1)), -- 0 or 1
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_mcp_server_scores FOREIGN KEY (mcp_server_id) REFERENCES mcp_server(id)
);

-- Score details table for individual scoring criteria
CREATE TABLE mcp_server_score_details (
    id NUMBER(10) DEFAULT seq_mcp_server_score_details.NEXTVAL PRIMARY KEY,
    score_id NUMBER(10) NOT NULL,
    criteria_name NVARCHAR2(255) NOT NULL,
    criteria_description NVARCHAR2(1000),
    is_met NUMBER(1) DEFAULT 0 CHECK (is_met IN (0, 1)), -- 0 or 1
    points_awarded NUMBER(3) DEFAULT 0 CHECK (points_awarded >= 0),
    max_points NUMBER(3) DEFAULT 0 CHECK (max_points >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_score_details FOREIGN KEY (score_id) REFERENCES mcp_server_scores(id)
);

-- MCP version history table to track version releases
CREATE TABLE mcp_version_history (
    id NUMBER(10) DEFAULT seq_mcp_version_history.NEXTVAL PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    version_number NVARCHAR2(20) NOT NULL,
    is_validated NUMBER(1) DEFAULT 0 CHECK (is_validated IN (0, 1)), -- 0 or 1
    published_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT uk_server_version UNIQUE (mcp_server_id, version_number),
    CONSTRAINT fk_mcp_version_history FOREIGN KEY (mcp_server_id) REFERENCES mcp_server(id)
);

-- MCP related servers table to store relationships between servers
CREATE TABLE mcp_related_servers (
    id NUMBER(10) DEFAULT seq_mcp_related_servers.NEXTVAL PRIMARY KEY,
    mcp_server_id NUMBER(10) NOT NULL,
    related_server_id NUMBER(10) NOT NULL,
    relationship_type NVARCHAR2(100), -- 'similar', 'complementary', 'alternative', etc.
    description NVARCHAR2(1000),
    is_active NUMBER(1) DEFAULT 1 NOT NULL CHECK (is_active IN (0, 1)),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT uk_server_relationship UNIQUE (mcp_server_id, related_server_id),
    CONSTRAINT fk_mcp_related_main FOREIGN KEY (mcp_server_id) REFERENCES mcp_server(id),
    CONSTRAINT fk_mcp_related_target FOREIGN KEY (related_server_id) REFERENCES mcp_server(id),
    CONSTRAINT chk_no_self_reference CHECK (mcp_server_id != related_server_id)
);