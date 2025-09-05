-- Sample Data Insertion Script for MCP Server Database
-- This script demonstrates how to populate the database with scraped data

-- Insert a sample MCP server (Playwright MCP)
INSERT INTO mcp_servers (
    name,
    version,
    author_vendor,
    published_date,
    development_language,
    license,
    total_downloads,
    stars,
    overview,
    installation_guide,
    installation_command,
    github_link,
    score_grade,
    score_percentage,
    server_type,
    short_description
) VALUES (
    'Playwright MCP',
    '0.0.36',
    'Microsoft Corporation',
    '2025-09-04',
    'TypeScript',
    'Apache License 2.0',
    1767,
    11971,
    'This is the README.md content for Playwright MCP server...',
    'Run the MCP server using ''uvx blender-mcp'' command after installing prerequisites and enabling the Blender addon. Ensure only one instance of the MCP server runs (either on Cursor or Claude Desktop).',
    'uvx blender-mcp',
    'https://github.com/microsoft/playwright-mcp',
    'A',
    85.5,
    'Local Service',
    'Playwright MCP provides browser automation capabilities through the Model Context Protocol.'
);

-- Get the ID of the inserted server
DECLARE @PlaywrightMCPId INT = SCOPE_IDENTITY();

-- Insert system dependencies
INSERT INTO system_dependencies (mcp_server_id, dependency_name, version_requirement, is_required) VALUES
(@PlaywrightMCPId, 'python', '>=3.10', 1),
(@PlaywrightMCPId, 'uv', 'installed', 1);

-- Link to installation platforms
INSERT INTO mcp_server_platforms (mcp_server_id, platform_id)
SELECT @PlaywrightMCPId, id FROM installation_platforms 
WHERE platform_name IN ('LobeChat', 'Claude', 'OpenAI', 'Cursor', 'VsCode', 'Cline');

-- Add some tags
INSERT INTO mcp_server_tags (mcp_server_id, tag_id)
SELECT @PlaywrightMCPId, id FROM tags 
WHERE tag_name IN ('Developer Tools', 'Browser Automation');

-- Insert tools for Playwright MCP
INSERT INTO mcp_tools (mcp_server_id, tool_name, instruction_description, input_description, tool_category) VALUES
(@PlaywrightMCPId, 'browser_close', 'Close the page', '{"type": "object", "$schema": "http://json-schema.org/draft-07/schema#", "properties": {}, "additionalProperties": false}', 'Browser Control'),
(@PlaywrightMCPId, 'browser_resize', 'Resize the browser window', '{"type": "object", "$schema": "http://json-schema.org/draft-07/schema#", "required": ["width", "height"], "properties": {"width": {"type": "number", "description": "Width of the browser window"}, "height": {"type": "number", "description": "Height of the browser window"}}, "additionalProperties": false}', 'Browser Control'),
(@PlaywrightMCPId, 'browser_navigate', 'Navigate to a URL', '{"type": "object", "$schema": "http://json-schema.org/draft-07/schema#", "required": ["url"], "properties": {"url": {"type": "string", "description": "The URL to navigate to"}}, "additionalProperties": false}', 'Browser Control'),
(@PlaywrightMCPId, 'browser_click', 'Perform click on a web page', '{"type": "object", "$schema": "http://json-schema.org/draft-07/schema#", "required": ["element", "ref"], "properties": {"element": {"type": "string", "description": "Human-readable element description"}, "ref": {"type": "string", "description": "Exact target element reference"}}, "additionalProperties": false}', 'Browser Interaction');

-- Insert version history
INSERT INTO version_history (mcp_server_id, version_number, published_date, is_validated) VALUES
(@PlaywrightMCPId, '0.0.36', '2025-09-01', 1),
(@PlaywrightMCPId, '0.0.35', '2025-08-29', 1),
(@PlaywrightMCPId, '0.0.34', '2025-08-16', 1),
(@PlaywrightMCPId, '0.0.33', '2025-08-09', 1),
(@PlaywrightMCPId, '0.0.32', '2025-07-26', 1),
(@PlaywrightMCPId, '0.0.31', '2025-07-18', 1),
(@PlaywrightMCPId, '0.0.30', '2025-07-15', 1),
(@PlaywrightMCPId, '0.0.29', '2025-06-16', 1);

-- Insert a related/recommended server (BlenderMCP)

    name,
    version,
    author_vendor,
    published_date,
    development_language,
    license,
    total_downloads,
    stars,
    overview,
    installation_guide,
    score_grade,
    score_percentage,
    server_type,
    short_description
) VALUES (
    'BlenderMCP',
    '1.0.0',
    'ahujasid',
    '2025-08-15',
    'Python',
    'MIT License',
    357,
    11579,
    'Blender Model Context Protocol Integration README content...',
    'Install using pip and configure Blender addon...',
    'https://github.com/ahujasid/blender-mcp',
    'A',
    92.0,
    'Local Service',
    'BlenderMCP connects Blender to Claude AI through the Model Context Protocol (MCP), allowing Claude to directly interact with and control Blender. This integration enables prompt assisted 3D modeling, scene creation, and manipulation. Requires Blender 3.0+ and Python 3.10+.'
);

DECLARE @BlenderMCPId INT = SCOPE_IDENTITY();

-- Add BlenderMCP tags
INSERT INTO mcp_server_tags (mcp_server_id, tag_id)
SELECT @BlenderMCPId, id FROM tags 
WHERE tag_name IN ('Developer Tools', 'Graphics/3D');

-- Create relationship between servers
-- NOTE: Front-end algorithm determines related servers. The following
-- INSERT is commented out to avoid persisting UI-driven recommendations.
-- INSERT INTO related_servers (source_server_id, related_server_id, relationship_type, relevance_score) VALUES
-- (@PlaywrightMCPId, @BlenderMCPId, 'recommended', 0.75);

-- Insert server rating data (for recommendations section)
INSERT INTO server_ratings (
    server_name,
    developer,
    rating_grade,
    is_premium,
    total_tools,
    total_prompts,
    total_downloads,
    stars,
    short_description,
    published_date,
    server_type
) VALUES (
    'BlenderMCP',
    'ahujasid',
    'A',
    1, -- PREMIUM
    17,
    1,
    357,
    11579,
    'BlenderMCP connects Blender to Claude AI through the Model Context Protocol (MCP), allowing Claude to directly interact with and control Blender. This integration enables prompt assisted 3D modeling, scene creation, and manipulation. Requires Blender 3.0+ and Python 3.10+. The uv package manager must be installed separately as per instructions.',
    '2025-08-15',
    'Local Service'
);

-- Sample query to verify data
SELECT 
    s.name,
    s.version,
    s.author_vendor,
    s.total_downloads,
    s.stars,
    s.score_grade,
    COUNT(t.id) as tool_count
FROM mcp_servers s
LEFT JOIN mcp_tools t ON s.id = t.mcp_server_id
GROUP BY s.id, s.name, s.version, s.author_vendor, s.total_downloads, s.stars, s.score_grade
ORDER BY s.stars DESC;
