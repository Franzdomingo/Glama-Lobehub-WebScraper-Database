-- Enhanced Sample Data with Score Examples for Glama.ai MCP Schema
-- Created: September 5, 2025
-- Purpose: Insert diverse MCP servers with different score profiles

-- Note: This script works with any database version (SQL Server, PostgreSQL, SQLite, Oracle)
-- Adjust syntax as needed for your specific database

-- Insert additional high-scoring MCP servers for testing

-- Perfect Score Example: Claude MCP
INSERT INTO mcp_servers (name, author, development_language, license, download_count, overview, server_slug, glama_url,
                        overall_score, score_grade, score_max_points, score_earned_points,
                        has_readme, has_license, has_glama_json, server_inspectable, has_tools, 
                        no_vulnerabilities, claimed_by_author, has_related_servers, score_last_updated) 
VALUES (
    'Claude MCP',
    'anthropic',
    'Python',
    'MIT',
    1250000,
    'Official Anthropic MCP server for Claude AI integration with comprehensive tools and resources.',
    'claude-mcp',
    'https://glama.ai/mcp/servers/claude-mcp',
    100.00, -- Perfect score
    'A+',   -- Grade
    100,    -- Max points possible
    100,    -- Points earned
    1,      -- Has README
    1,      -- Has LICENSE
    1,      -- Has glama.json
    1,      -- Server inspectable
    1,      -- Has tools
    1,      -- No vulnerabilities
    1,      -- Claimed by author
    1,      -- Has related servers
    GETDATE() -- Use CURRENT_TIMESTAMP for PostgreSQL/SQLite, CURRENT_TIMESTAMP for Oracle
);

-- High Score Example: Notion MCP
INSERT INTO mcp_servers (name, author, development_language, license, download_count, overview, server_slug, glama_url,
                        overall_score, score_grade, score_max_points, score_earned_points,
                        has_readme, has_license, has_glama_json, server_inspectable, has_tools, 
                        no_vulnerabilities, claimed_by_author, has_related_servers, score_last_updated) 
VALUES (
    'Notion MCP',
    'notion-team',
    'TypeScript',
    'Apache 2.0',
    890000,
    'Official Notion MCP server for database operations, page management, and content creation.',
    'notion-mcp',
    'https://glama.ai/mcp/servers/notion-mcp',
    95.00,  -- 95% score
    'A',    -- Grade
    100,    -- Max points possible
    95,     -- Points earned
    1,      -- Has README
    1,      -- Has LICENSE
    1,      -- Has glama.json
    1,      -- Server inspectable
    1,      -- Has tools
    1,      -- No vulnerabilities
    1,      -- Claimed by author
    0,      -- No related servers
    GETDATE()
);

-- Medium Score Example: SQLite MCP
INSERT INTO mcp_servers (name, author, development_language, license, download_count, overview, server_slug, glama_url,
                        overall_score, score_grade, score_max_points, score_earned_points,
                        has_readme, has_license, has_glama_json, server_inspectable, has_tools, 
                        no_vulnerabilities, claimed_by_author, has_related_servers, score_last_updated) 
VALUES (
    'SQLite MCP',
    'community-dev',
    'Python',
    'GPL-3.0',
    125000,
    'Community-maintained MCP server for SQLite database operations and queries.',
    'sqlite-mcp',
    'https://glama.ai/mcp/servers/sqlite-mcp',
    65.00,  -- 65% score
    'C+',   -- Grade
    100,    -- Max points possible
    65,     -- Points earned
    1,      -- Has README
    1,      -- Has LICENSE
    0,      -- No glama.json
    1,      -- Server inspectable
    1,      -- Has tools
    0,      -- Has vulnerabilities
    0,      -- Not claimed by author
    0,      -- No related servers
    GETDATE()
);

-- Low Score Example: Basic File MCP
INSERT INTO mcp_servers (name, author, development_language, license, download_count, overview, server_slug, glama_url,
                        overall_score, score_grade, score_max_points, score_earned_points,
                        has_readme, has_license, has_glama_json, server_inspectable, has_tools, 
                        no_vulnerabilities, claimed_by_author, has_related_servers, score_last_updated) 
VALUES (
    'Basic File MCP',
    'unknown-dev',
    'JavaScript',
    NULL, -- No license
    5000,
    'Basic file operations MCP server with minimal documentation.',
    'basic-file-mcp',
    'https://glama.ai/mcp/servers/basic-file-mcp',
    30.00,  -- 30% score
    'D',    -- Grade
    100,    -- Max points possible
    30,     -- Points earned
    0,      -- No README
    0,      -- No LICENSE
    0,      -- No glama.json
    0,      -- Not inspectable
    1,      -- Has tools
    0,      -- Has vulnerabilities
    0,      -- Not claimed by author
    0,      -- No related servers
    GETDATE()
);

-- Add some categories for the new servers
-- Note: Adjust category insertion based on your database's auto-increment behavior

-- Claude MCP categories
INSERT INTO server_categories (mcp_server_id, category_id)
SELECT s.id, c.id 
FROM mcp_servers s, categories c 
WHERE s.name = 'Claude MCP' AND c.category_name IN ('Coding Agents', 'Developer Tools', 'Autonomous Agents');

-- Notion MCP categories
INSERT INTO server_categories (mcp_server_id, category_id)
SELECT s.id, c.id 
FROM mcp_servers s, categories c 
WHERE s.name = 'Notion MCP' AND c.category_name IN ('Workplace & Productivity', 'Note Taking', 'Content Management Systems');

-- SQLite MCP categories
INSERT INTO server_categories (mcp_server_id, category_id)
SELECT s.id, c.id 
FROM mcp_servers s, categories c 
WHERE s.name = 'SQLite MCP' AND c.category_name IN ('Databases', 'Developer Tools', 'Data Platforms');

-- Basic File MCP categories
INSERT INTO server_categories (mcp_server_id, category_id)
SELECT s.id, c.id 
FROM mcp_servers s, categories c 
WHERE s.name = 'Basic File MCP' AND c.category_name IN ('File Systems', 'Developer Tools');

-- Add some sample tools for the new servers

-- Claude MCP tools
INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order)
SELECT s.id, 'claude_chat', 'Send messages to Claude AI for processing', 'AI Communication', 1
FROM mcp_servers s WHERE s.name = 'Claude MCP';

INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order)
SELECT s.id, 'claude_analysis', 'Perform text analysis using Claude', 'AI Analysis', 2
FROM mcp_servers s WHERE s.name = 'Claude MCP';

-- Notion MCP tools
INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order)
SELECT s.id, 'create_page', 'Create a new Notion page', 'Content Management', 1
FROM mcp_servers s WHERE s.name = 'Notion MCP';

INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order)
SELECT s.id, 'query_database', 'Query Notion database with filters', 'Data Retrieval', 2
FROM mcp_servers s WHERE s.name = 'Notion MCP';

-- SQLite MCP tools
INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order)
SELECT s.id, 'execute_query', 'Execute SQL query on SQLite database', 'Database Operations', 1
FROM mcp_servers s WHERE s.name = 'SQLite MCP';

-- Basic File MCP tools
INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order)
SELECT s.id, 'read_file', 'Read file contents', 'File Operations', 1
FROM mcp_servers s WHERE s.name = 'Basic File MCP';

-- Add some links for the new servers

-- Claude MCP links
INSERT INTO server_links (mcp_server_id, link_type_id, url, link_text, is_primary)
SELECT s.id, lt.id, 'https://github.com/anthropic/claude-mcp', 'Official Repository', 1
FROM mcp_servers s, link_types lt 
WHERE s.name = 'Claude MCP' AND lt.type_name = 'github';

-- Notion MCP links
INSERT INTO server_links (mcp_server_id, link_type_id, url, link_text, is_primary)
SELECT s.id, lt.id, 'https://www.npmjs.com/package/@notion/mcp', 'NPM Package', 1
FROM mcp_servers s, link_types lt 
WHERE s.name = 'Notion MCP' AND lt.type_name = 'npm';

INSERT INTO server_links (mcp_server_id, link_type_id, url, link_text, is_primary)
SELECT s.id, lt.id, 'https://developers.notion.com/mcp', 'Documentation', 1
FROM mcp_servers s, link_types lt 
WHERE s.name = 'Notion MCP' AND lt.type_name = 'documentation';

-- Print summary statistics
-- Note: Comment out the PRINT statements for non-SQL Server databases

/*
DECLARE @total_servers INT, @avg_score DECIMAL(5,2);
SELECT @total_servers = COUNT(*), @avg_score = AVG(overall_score) 
FROM mcp_servers WHERE overall_score IS NOT NULL;

PRINT 'Sample data insertion completed!';
PRINT 'Total MCP servers: ' + CAST(@total_servers AS VARCHAR(10));
PRINT 'Average score: ' + CAST(@avg_score AS VARCHAR(10)) + '%';

-- Show score distribution
SELECT 
    score_grade,
    COUNT(*) as server_count,
    AVG(overall_score) as avg_score,
    MIN(overall_score) as min_score,
    MAX(overall_score) as max_score
FROM mcp_servers 
WHERE score_grade IS NOT NULL
GROUP BY score_grade
ORDER BY avg_score DESC;
*/
