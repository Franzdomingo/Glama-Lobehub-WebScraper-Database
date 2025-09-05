-- Sample Data Insertion Script for MCP Server Database - Oracle Version
-- This script demonstrates how to populate the Oracle database with scraped data

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
    github_link,
    overview,
    installation_guide,
    installation_command,
    score_grade,
    score_percentage,
    server_type,
    short_description
) VALUES (
    'Playwright MCP',
    '0.0.36',
    'Microsoft Corporation',
    DATE '2025-09-04',
    'TypeScript',
    'Apache License 2.0',
    1767,
    11971,
    'https://github.com/microsoft/playwright-mcp',
    'This is the README.md content for Playwright MCP server...',
    'Run the MCP server using ''uvx blender-mcp'' command after installing prerequisites and enabling the Blender addon. Ensure only one instance of the MCP server runs (either on Cursor or Claude Desktop).',
    'uvx blender-mcp',
    'A',
    85.5,
    'Local Service',
    'Playwright MCP provides browser automation capabilities through the Model Context Protocol.'
);

-- Get the ID of the inserted server (Oracle way)
DECLARE
    v_playwright_id NUMBER;
BEGIN
    -- Get the server ID
    SELECT id INTO v_playwright_id 
    FROM mcp_servers 
    WHERE name = 'Playwright MCP' AND version = '0.0.36';
    
    -- Insert system dependencies
    INSERT INTO system_dependencies (mcp_server_id, dependency_name, version_requirement, is_required) VALUES
    (v_playwright_id, 'python', '>=3.10', 1);
    
    INSERT INTO system_dependencies (mcp_server_id, dependency_name, version_requirement, is_required) VALUES
    (v_playwright_id, 'uv', 'installed', 1);
    
    -- Link to installation platforms
    INSERT INTO mcp_server_platforms (mcp_server_id, platform_id)
    SELECT v_playwright_id, p.id 
    FROM installation_platforms p
    WHERE p.platform_name IN ('LobeChat', 'Claude', 'OpenAI', 'Cursor', 'VsCode', 'Cline');
    
    -- Add some tags
    INSERT INTO mcp_server_tags (mcp_server_id, tag_id)
    SELECT v_playwright_id, t.id 
    FROM tags t
    WHERE t.tag_name IN ('Developer Tools', 'Utility Tools');
    
    -- Insert tools for Playwright MCP using INSERT ALL
    INSERT ALL
        INTO mcp_tools (mcp_server_id, tool_name, instruction_description, input_description, tool_category) 
        VALUES (v_playwright_id, 'browser_close', 'Close the page', '{"type": "object", "$schema": "http://json-schema.org/draft-07/schema#", "properties": {}, "additionalProperties": false}', 'Browser Control')
        INTO mcp_tools (mcp_server_id, tool_name, instruction_description, input_description, tool_category) 
        VALUES (v_playwright_id, 'browser_resize', 'Resize the browser window', '{"type": "object", "$schema": "http://json-schema.org/draft-07/schema#", "required": ["width", "height"], "properties": {"width": {"type": "number", "description": "Width of the browser window"}, "height": {"type": "number", "description": "Height of the browser window"}}, "additionalProperties": false}', 'Browser Control')
        INTO mcp_tools (mcp_server_id, tool_name, instruction_description, input_description, tool_category) 
        VALUES (v_playwright_id, 'browser_navigate', 'Navigate to a URL', '{"type": "object", "$schema": "http://json-schema.org/draft-07/schema#", "required": ["url"], "properties": {"url": {"type": "string", "description": "The URL to navigate to"}}, "additionalProperties": false}', 'Browser Control')
        INTO mcp_tools (mcp_server_id, tool_name, instruction_description, input_description, tool_category) 
        VALUES (v_playwright_id, 'browser_click', 'Perform click on a web page', '{"type": "object", "$schema": "http://json-schema.org/draft-07/schema#", "required": ["element", "ref"], "properties": {"element": {"type": "string", "description": "Human-readable element description"}, "ref": {"type": "string", "description": "Exact target element reference"}}, "additionalProperties": false}', 'Browser Interaction')
    SELECT * FROM dual;
    
    -- Insert version history using INSERT ALL
    INSERT ALL
        INTO version_history (mcp_server_id, version_number, published_date, is_validated) VALUES (v_playwright_id, '0.0.36', DATE '2025-09-01', 1)
        INTO version_history (mcp_server_id, version_number, published_date, is_validated) VALUES (v_playwright_id, '0.0.35', DATE '2025-08-29', 1)
        INTO version_history (mcp_server_id, version_number, published_date, is_validated) VALUES (v_playwright_id, '0.0.34', DATE '2025-08-16', 1)
        INTO version_history (mcp_server_id, version_number, published_date, is_validated) VALUES (v_playwright_id, '0.0.33', DATE '2025-08-09', 1)
        INTO version_history (mcp_server_id, version_number, published_date, is_validated) VALUES (v_playwright_id, '0.0.32', DATE '2025-07-26', 1)
        INTO version_history (mcp_server_id, version_number, published_date, is_validated) VALUES (v_playwright_id, '0.0.31', DATE '2025-07-18', 1)
        INTO version_history (mcp_server_id, version_number, published_date, is_validated) VALUES (v_playwright_id, '0.0.30', DATE '2025-07-15', 1)
        INTO version_history (mcp_server_id, version_number, published_date, is_validated) VALUES (v_playwright_id, '0.0.29', DATE '2025-06-16', 1)
    SELECT * FROM dual;
    
    -- Commit the transaction
    COMMIT;
    
    -- Display success message
    DBMS_OUTPUT.PUT_LINE('Successfully inserted Playwright MCP server with ID: ' || v_playwright_id);
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
        RAISE;
END;
/

-- Insert a related/recommended server (BlenderMCP)
INSERT INTO mcp_servers (
    name,
    version,
    author_vendor,
    published_date,
    development_language,
    license,
    total_downloads,
    stars,
    github_link,
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
    DATE '2025-08-15',
    'Python',
    'MIT License',
    357,
    11579,
    'https://github.com/ahujasid/blender-mcp',
    'Blender Model Context Protocol Integration README content...',
    'Install using pip and configure Blender addon...',
    'A',
    92.0,
    'Local Service',
    'BlenderMCP connects Blender to Claude AI through the Model Context Protocol (MCP), allowing Claude to directly interact with and control Blender. This integration enables prompt assisted 3D modeling, scene creation, and manipulation. Requires Blender 3.0+ and Python 3.10+.'
);

-- Create relationship between servers and add metadata for BlenderMCP
DECLARE
    v_playwright_id NUMBER;
    v_blender_id NUMBER;
BEGIN
    -- Get server IDs
    SELECT id INTO v_playwright_id FROM mcp_servers WHERE name = 'Playwright MCP';
    SELECT id INTO v_blender_id FROM mcp_servers WHERE name = 'BlenderMCP';
    
    -- Add BlenderMCP tags
    INSERT INTO mcp_server_tags (mcp_server_id, tag_id)
    SELECT v_blender_id, t.id 
    FROM tags t
    WHERE t.tag_name IN ('Developer Tools', 'Media Generation');
    
    -- Create relationship between servers
    -- NOTE: Front-end algorithm determines related servers. The following
    -- INSERT is commented out to avoid persisting UI-driven recommendations.
    -- INSERT INTO related_servers (
    --     source_server_id, 
    --     related_server_id, 
    --     relationship_type, 
    --     relevance_score,
    --     recommendation_reason,
    --     display_order
    -- ) VALUES (
    --     v_playwright_id, 
    --     v_blender_id, 
    --     'recommended', 
    --     0.75,
    --     'Both servers provide automation capabilities for creative workflows',
    --     1
    -- );
    
    -- Insert metadata for Playwright MCP
    INSERT INTO server_metadata (
        mcp_server_id,
        is_premium,
        is_featured,
        quality_score,
        maintenance_status,
        documentation_quality,
        community_rating,
        last_activity_date
    ) VALUES (
        v_playwright_id,
        0, -- Not premium
        1, -- Featured
        92.5,
        'active',
        'A',
        4.8,
        DATE '2025-09-04'
    );
    
    -- Insert metadata for BlenderMCP
    INSERT INTO server_metadata (
        mcp_server_id,
        is_premium,
        is_featured,
        quality_score,
        maintenance_status,
        documentation_quality,
        community_rating,
        last_activity_date
    ) VALUES (
        v_blender_id,
        1, -- Premium
        1, -- Featured
        89.0,
        'active',
        'A',
        4.6,
        DATE '2025-08-15'
    );
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Successfully created relationships and metadata');
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error in relationships: ' || SQLERRM);
        RAISE;
END;
/

-- Sample queries to verify data and demonstrate improved schema

-- 1. Get servers with their metadata, tool counts, and GitHub links
SELECT 
    s.name,
    s.version,
    s.author_vendor,
    s.github_link,
    s.total_downloads,
    s.stars,
    s.score_grade,
    sm.is_premium,
    sm.is_featured,
    sm.quality_score,
    sm.maintenance_status,
    sm.community_rating,
    COUNT(t.id) as tool_count
FROM mcp_servers s
LEFT JOIN mcp_tools t ON s.id = t.mcp_server_id
LEFT JOIN server_metadata sm ON s.id = sm.mcp_server_id
GROUP BY s.id, s.name, s.version, s.author_vendor, s.github_link, s.total_downloads, s.stars, s.score_grade,
         sm.is_premium, sm.is_featured, sm.quality_score, sm.maintenance_status, sm.community_rating
ORDER BY s.stars DESC;

-- 2. Get server recommendations with proper relationships and GitHub links
SELECT 
    source.name AS source_server,
    source.github_link AS source_github,
    related.name AS recommended_server,
    related.github_link AS recommended_github,
    rs.relationship_type,
    rs.relevance_score,
    rs.recommendation_reason,
    related.score_grade,
    related.stars,
    sm.is_premium,
    sm.quality_score
FROM related_servers rs
JOIN mcp_servers source ON rs.source_server_id = source.id
JOIN mcp_servers related ON rs.related_server_id = related.id
LEFT JOIN server_metadata sm ON related.id = sm.mcp_server_id
WHERE rs.is_active = 1
ORDER BY rs.display_order, rs.relevance_score DESC;

-- 3. Get premium servers with high quality scores and their GitHub repositories
SELECT 
    s.name,
    s.author_vendor,
    s.github_link,
    s.score_grade,
    sm.quality_score,
    sm.community_rating,
    s.stars,
    s.total_downloads
FROM mcp_servers s
JOIN server_metadata sm ON s.id = sm.mcp_server_id
WHERE sm.is_premium = 1 
  AND sm.quality_score > 85
  AND s.github_link IS NOT NULL
ORDER BY sm.quality_score DESC, s.stars DESC;

-- 4. Find servers by GitHub organization (e.g., Microsoft)
SELECT 
    s.name,
    s.version,
    s.github_link,
    s.stars,
    s.score_grade,
    sm.quality_score
FROM mcp_servers s
LEFT JOIN server_metadata sm ON s.id = sm.mcp_server_id
WHERE s.github_link LIKE '%github.com/microsoft%'
ORDER BY s.stars DESC;

-- Enable DBMS_OUTPUT to see messages
SET SERVEROUTPUT ON;
