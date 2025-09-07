-- MCP Server Database Schema - Oracle Version
-- Created: September 5, 2025
-- Purpose: Store scraped data from MCP server listings website
-- Compatible with: Oracle Database 11g+

-- Main MCP Servers table
CREATE TABLE mcp_servers (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(255) NOT NULL,
    version VARCHAR2(50),
    author_vendor VARCHAR2(255),
    published_date DATE,
    development_language VARCHAR2(100),
    license VARCHAR2(255),
    total_downloads NUMBER DEFAULT 0,
    stars NUMBER DEFAULT 0,
    github_link VARCHAR2(500), -- GitHub repository URL
    overview CLOB, -- README.md content
    installation_guide CLOB,
    installation_command VARCHAR2(500),
    score_grade CHAR(1) CHECK (score_grade IN ('A', 'B', 'F')),
    score_percentage NUMBER(5,2),
    server_type VARCHAR2(100), -- e.g., 'Local Service'
    short_description VARCHAR2(1000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    scraped_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create sequence for mcp_servers
CREATE SEQUENCE mcp_servers_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Create trigger for auto-increment on mcp_servers
CREATE OR REPLACE TRIGGER mcp_servers_trigger
    BEFORE INSERT ON mcp_servers
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        :NEW.id := mcp_servers_seq.NEXTVAL;
    END IF;
END;
/

-- Installation Platforms/Methods
CREATE TABLE installation_platforms (
    id NUMBER PRIMARY KEY,
    platform_name VARCHAR2(100) NOT NULL UNIQUE -- LobeChat, Claude, OpenAI, Cursor, VsCode, Cline
);

-- Create sequence for installation_platforms
CREATE SEQUENCE installation_platforms_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Create trigger for auto-increment on installation_platforms
CREATE OR REPLACE TRIGGER installation_platforms_trigger
    BEFORE INSERT ON installation_platforms
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        :NEW.id := installation_platforms_seq.NEXTVAL;
    END IF;
END;
/

-- Junction table for MCP Server - Installation Platform relationship
CREATE TABLE mcp_server_platforms (
    id NUMBER PRIMARY KEY,
    mcp_server_id NUMBER NOT NULL,
    platform_id NUMBER NOT NULL,
    CONSTRAINT fk_mcp_server_platforms_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT fk_mcp_server_platforms_platform FOREIGN KEY (platform_id) REFERENCES installation_platforms(id) ON DELETE CASCADE,
    CONSTRAINT uk_mcp_server_platforms UNIQUE(mcp_server_id, platform_id)
);

-- Create sequence for mcp_server_platforms
CREATE SEQUENCE mcp_server_platforms_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Create trigger for auto-increment on mcp_server_platforms
CREATE OR REPLACE TRIGGER mcp_server_platforms_trigger
    BEFORE INSERT ON mcp_server_platforms
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        :NEW.id := mcp_server_platforms_seq.NEXTVAL;
    END IF;
END;
/

-- System Dependencies
CREATE TABLE system_dependencies (
    id NUMBER PRIMARY KEY,
    mcp_server_id NUMBER NOT NULL,
    dependency_name VARCHAR2(100) NOT NULL,
    version_requirement VARCHAR2(100),
    is_required NUMBER(1) DEFAULT 1 CHECK (is_required IN (0,1)),
    CONSTRAINT fk_system_dependencies_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Create sequence for system_dependencies
CREATE SEQUENCE system_dependencies_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Create trigger for auto-increment on system_dependencies
CREATE OR REPLACE TRIGGER system_dependencies_trigger
    BEFORE INSERT ON system_dependencies
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        :NEW.id := system_dependencies_seq.NEXTVAL;
    END IF;
END;
/

-- Tools/Functions exposed by MCP servers
CREATE TABLE mcp_tools (
    id NUMBER PRIMARY KEY,
    mcp_server_id NUMBER NOT NULL,
    tool_name VARCHAR2(255) NOT NULL,
    instruction_description VARCHAR2(1000),
    input_description CLOB, -- JSON schema
    tool_category VARCHAR2(100),
    is_active NUMBER(1) DEFAULT 1 CHECK (is_active IN (0,1)),
    CONSTRAINT fk_mcp_tools_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Create sequence for mcp_tools
CREATE SEQUENCE mcp_tools_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Create trigger for auto-increment on mcp_tools
CREATE OR REPLACE TRIGGER mcp_tools_trigger
    BEFORE INSERT ON mcp_tools
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        :NEW.id := mcp_tools_seq.NEXTVAL;
    END IF;
END;
/

-- Prompts available for MCP servers
CREATE TABLE mcp_prompts (
    id NUMBER PRIMARY KEY,
    mcp_server_id NUMBER NOT NULL,
    prompt_name VARCHAR2(255) NOT NULL,
    prompt_description VARCHAR2(1000),
    prompt_content CLOB,
    prompt_arguments CLOB, -- JSON schema for arguments
    usage_examples CLOB, -- Usage examples or example prompts
    is_active NUMBER(1) DEFAULT 1 CHECK (is_active IN (0,1)),
    CONSTRAINT fk_mcp_prompts_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Create sequence for mcp_prompts
CREATE SEQUENCE mcp_prompts_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Create trigger for auto-increment on mcp_prompts
CREATE OR REPLACE TRIGGER mcp_prompts_trigger
    BEFORE INSERT ON mcp_prompts
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        :NEW.id := mcp_prompts_seq.NEXTVAL;
    END IF;
END;
/

-- Tags for categorization
CREATE TABLE tags (
    id NUMBER PRIMARY KEY,
    tag_name VARCHAR2(100) NOT NULL UNIQUE -- Developer Tools, AI/ML, etc.
);

-- Create sequence for tags
CREATE SEQUENCE tags_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Create trigger for auto-increment on tags
CREATE OR REPLACE TRIGGER tags_trigger
    BEFORE INSERT ON tags
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        :NEW.id := tags_seq.NEXTVAL;
    END IF;
END;
/

-- Junction table for MCP Server - Tags relationship
CREATE TABLE mcp_server_tags (
    id NUMBER PRIMARY KEY,
    mcp_server_id NUMBER NOT NULL,
    tag_id NUMBER NOT NULL,
    CONSTRAINT fk_mcp_server_tags_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT fk_mcp_server_tags_tag FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE,
    CONSTRAINT uk_mcp_server_tags UNIQUE(mcp_server_id, tag_id)
);

-- Create sequence for mcp_server_tags
CREATE SEQUENCE mcp_server_tags_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Create trigger for auto-increment on mcp_server_tags
CREATE OR REPLACE TRIGGER mcp_server_tags_trigger
    BEFORE INSERT ON mcp_server_tags
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        :NEW.id := mcp_server_tags_seq.NEXTVAL;
    END IF;
END;
/

-- Version History
CREATE TABLE version_history (
    id NUMBER PRIMARY KEY,
    mcp_server_id NUMBER NOT NULL,
    version_number VARCHAR2(50) NOT NULL,
    published_date DATE,
    is_validated NUMBER(1) DEFAULT 0 CHECK (is_validated IN (0,1)),
    release_notes CLOB,
    CONSTRAINT fk_version_history_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Create sequence for version_history
CREATE SEQUENCE version_history_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Create trigger for auto-increment on version_history
CREATE OR REPLACE TRIGGER version_history_trigger
    BEFORE INSERT ON version_history
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        :NEW.id := version_history_seq.NEXTVAL;
    END IF;
END;
/

-- Related/Recommended MCP Servers
-- Related/Recommended MCP Servers
-- NOTE: Related servers are surfaced by a front-end recommendation algorithm
-- and are not strictly necessary to store in the core database schema.
-- The table and its supporting sequence/trigger are retained here
-- commented out in case you later decide to persist recommendations server-side.
--
-- CREATE TABLE related_servers (
--     id NUMBER PRIMARY KEY,
--     source_server_id NUMBER NOT NULL,
--     related_server_id NUMBER NOT NULL,
--     relationship_type VARCHAR2(50) DEFAULT 'recommended', -- recommended, similar, alternative
--     relevance_score NUMBER(3,2), -- 0.00 to 1.00
--     recommendation_reason VARCHAR2(500), -- Why this server is recommended
--     display_order NUMBER DEFAULT 0, -- Order to display recommendations
--     is_active NUMBER(1) DEFAULT 1 CHECK (is_active IN (0,1)), -- Can disable recommendations
--     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--     CONSTRAINT fk_related_servers_source FOREIGN KEY (source_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
--     CONSTRAINT fk_related_servers_related FOREIGN KEY (related_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
--     CONSTRAINT uk_related_servers UNIQUE(source_server_id, related_server_id) -- Prevent duplicate relationships
-- );
--
-- -- Create sequence for related_servers
-- CREATE SEQUENCE related_servers_seq
--     START WITH 1
--     INCREMENT BY 1
--     NOCACHE;
--
-- -- Create trigger for auto-increment on related_servers
-- CREATE OR REPLACE TRIGGER related_servers_trigger
--     BEFORE INSERT ON related_servers
--     FOR EACH ROW
-- BEGIN
--     IF :NEW.id IS NULL THEN
--         :NEW.id := related_servers_seq.NEXTVAL;
--     END IF;
-- END;
-- /

-- Additional server metadata that doesn't fit in main table
CREATE TABLE server_metadata (
    id NUMBER PRIMARY KEY,
    mcp_server_id NUMBER NOT NULL,
    is_premium NUMBER(1) DEFAULT 0 CHECK (is_premium IN (0,1)),
    is_featured NUMBER(1) DEFAULT 0 CHECK (is_featured IN (0,1)),
    quality_score NUMBER(3,1), -- 0.0 to 100.0 for more granular scoring
    maintenance_status VARCHAR2(20) DEFAULT 'active', -- active, deprecated, archived
    documentation_quality CHAR(1) CHECK (documentation_quality IN ('A', 'B', 'C', 'D', 'F')),
    community_rating NUMBER(3,2), -- User community rating 0.00 to 5.00
    last_activity_date DATE, -- Last commit, release, or update
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_server_metadata_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE,
    CONSTRAINT uk_server_metadata_server UNIQUE(mcp_server_id) -- One metadata record per server
);

-- Create sequence for server_metadata
CREATE SEQUENCE server_metadata_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Create trigger for auto-increment on server_metadata
CREATE OR REPLACE TRIGGER server_metadata_trigger
    BEFORE INSERT ON server_metadata
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        :NEW.id := server_metadata_seq.NEXTVAL;
    END IF;
    -- Auto-update the updated_at timestamp
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

-- Create trigger for auto-updating updated_at on server_metadata
CREATE OR REPLACE TRIGGER server_metadata_update_trigger
    BEFORE UPDATE ON server_metadata
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

-- Create indexes for better performance
CREATE INDEX idx_mcp_servers_name ON mcp_servers(name);
CREATE INDEX idx_mcp_servers_author ON mcp_servers(author_vendor);
CREATE INDEX idx_mcp_servers_published_date ON mcp_servers(published_date);
CREATE INDEX idx_mcp_servers_score_grade ON mcp_servers(score_grade);
CREATE INDEX idx_mcp_servers_stars ON mcp_servers(stars);
CREATE INDEX idx_mcp_servers_downloads ON mcp_servers(total_downloads);
CREATE INDEX idx_mcp_servers_github ON mcp_servers(github_link);
CREATE INDEX idx_mcp_tools_server_id ON mcp_tools(mcp_server_id);
CREATE INDEX idx_version_history_server_id ON version_history(mcp_server_id);
CREATE INDEX idx_version_history_date ON version_history(published_date);
CREATE INDEX idx_related_servers_source ON related_servers(source_server_id);
CREATE INDEX idx_related_servers_related ON related_servers(related_server_id);
CREATE INDEX idx_related_servers_type ON related_servers(relationship_type);
CREATE INDEX idx_server_metadata_server ON server_metadata(mcp_server_id);
CREATE INDEX idx_server_metadata_premium ON server_metadata(is_premium);
CREATE INDEX idx_server_metadata_featured ON server_metadata(is_featured);
CREATE INDEX idx_server_metadata_maintenance ON server_metadata(maintenance_status);

-- MCP Resources (contextual data attached and managed by the client)
CREATE TABLE mcp_resources (
    id NUMBER PRIMARY KEY,
    mcp_server_id NUMBER NOT NULL,
    resource_name VARCHAR2(255) NOT NULL,
    resource_description CLOB,
    CONSTRAINT fk_mcp_resources_server FOREIGN KEY (mcp_server_id) REFERENCES mcp_servers(id) ON DELETE CASCADE
);

-- Create sequence for mcp_resources
CREATE SEQUENCE mcp_resources_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Create trigger for auto-increment on mcp_resources
CREATE OR REPLACE TRIGGER mcp_resources_trigger
    BEFORE INSERT ON mcp_resources
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        :NEW.id := mcp_resources_seq.NEXTVAL;
    END IF;
END;
/ 

CREATE INDEX idx_mcp_resources_server_id ON mcp_resources(mcp_server_id);
-- idx_mcp_resources_type removed (resource_type field simplified away)
-- idx_mcp_resources_active removed (is_active field simplified away)

-- Insert some common installation platforms
INSERT ALL
    INTO installation_platforms (platform_name) VALUES ('LobeChat')
    INTO installation_platforms (platform_name) VALUES ('Claude')
    INTO installation_platforms (platform_name) VALUES ('OpenAI')
    INTO installation_platforms (platform_name) VALUES ('Cursor')
    INTO installation_platforms (platform_name) VALUES ('VsCode')
    INTO installation_platforms (platform_name) VALUES ('Cline')
SELECT * FROM dual;

-- Insert common tags
INSERT ALL
    INTO tags (tag_name) VALUES ('Developer Tools')
    INTO tags (tag_name) VALUES ('Productivity Tools')
    INTO tags (tag_name) VALUES ('Utility Tools')
    INTO tags (tag_name) VALUES ('Information Retrieval')
    INTO tags (tag_name) VALUES ('Media Generation')
    INTO tags (tag_name) VALUES ('Business Services')
    INTO tags (tag_name) VALUES ('Science & Education')
    INTO tags (tag_name) VALUES ('Stocks & Finance')
    INTO tags (tag_name) VALUES ('News & Information')
    INTO tags (tag_name) VALUES ('Social Media')
    INTO tags (tag_name) VALUES ('Gaming & Entertainment')
    INTO tags (tag_name) VALUES ('Lifestyle')
    INTO tags (tag_name) VALUES ('Health & Wellness')
    INTO tags (tag_name) VALUES ('Travel & Transport')
    INTO tags (tag_name) VALUES ('Weather')
SELECT * FROM dual;

-- Commit all changes
COMMIT;
