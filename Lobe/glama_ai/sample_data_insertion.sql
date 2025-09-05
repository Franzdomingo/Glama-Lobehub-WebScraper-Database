-- Sample Data Insertion Script for Glama.ai MCP Schema
-- Created: September 5, 2025
-- Purpose: Insert comprehensive sample data for Playwright MCP server

-- This assumes the Playwright MCP server has already been inserted in the schema files
-- Get the server ID for reference
DECLARE @playwright_server_id INT = (SELECT id FROM mcp_servers WHERE name = 'Playwright MCP');

-- Insert score criteria if not already present
IF NOT EXISTS (SELECT 1 FROM server_score_criteria WHERE criteria_name = 'has_readme')
BEGIN
    INSERT INTO server_score_criteria (criteria_name, criteria_description, max_points, display_order) VALUES 
    ('has_readme', 'Repository has a README.md file', 10, 1),
    ('has_license', 'The repository has a LICENSE file', 10, 2),
    ('has_glama_json', 'Repository has a valid glama.json configuration file', 15, 3),
    ('server_inspectable', 'Server can be inspected through server inspector', 15, 4),
    ('has_tools', 'Server has at least one tool defined in schema', 20, 5),
    ('no_vulnerabilities', 'Server has no known security vulnerabilities', 15, 6),
    ('claimed_by_author', 'Server is claimed and verified by the original author', 10, 7),
    ('has_related_servers', 'Server has user-submitted related MCP servers for discoverability', 5, 8);
END

-- Insert MCP Tools based on the provided list
INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
(@playwright_server_id, 'start_codegen_session', 'Start a new code generation session to record Playwright actions', 'Code Generation', 1),
(@playwright_server_id, 'end_codegen_session', 'End a code generation session and generate the test file', 'Code Generation', 2),
(@playwright_server_id, 'get_codegen_session', 'Get information about a code generation session', 'Code Generation', 3),
(@playwright_server_id, 'clear_codegen_session', 'Clear a code generation session without generating a test', 'Code Generation', 4),
(@playwright_server_id, 'playwright_navigate', 'Navigate to a URL', 'Navigation', 5),
(@playwright_server_id, 'playwright_screenshot', 'Take a screenshot of the current page or a specific element', 'Capture', 6),
(@playwright_server_id, 'playwright_click', 'Click an element on the page', 'Interaction', 7),
(@playwright_server_id, 'playwright_iframe_click', 'Click an element in an iframe on the page', 'Interaction', 8),
(@playwright_server_id, 'playwright_iframe_fill', 'Fill an element in an iframe on the page', 'Interaction', 9),
(@playwright_server_id, 'playwright_fill', 'Fill out an input field', 'Interaction', 10),
(@playwright_server_id, 'playwright_select', 'Select an element on the page with Select tag', 'Interaction', 11),
(@playwright_server_id, 'playwright_hover', 'Hover an element on the page', 'Interaction', 12),
(@playwright_server_id, 'playwright_evaluate', 'Execute JavaScript in the browser console', 'Scripting', 13),
(@playwright_server_id, 'playwright_console_logs', 'Retrieve console logs from the browser with filtering options', 'Debugging', 14),
(@playwright_server_id, 'playwright_close', 'Close the browser and release all resources', 'Control', 15),
(@playwright_server_id, 'playwright_get', 'Perform an HTTP GET request', 'HTTP', 16),
(@playwright_server_id, 'playwright_post', 'Perform an HTTP POST request', 'HTTP', 17),
(@playwright_server_id, 'playwright_put', 'Perform an HTTP PUT request', 'HTTP', 18),
(@playwright_server_id, 'playwright_patch', 'Perform an HTTP PATCH request', 'HTTP', 19),
(@playwright_server_id, 'playwright_delete', 'Perform an HTTP DELETE request', 'HTTP', 20),
(@playwright_server_id, 'playwright_expect_response', 'Ask Playwright to start waiting for a HTTP response. This tool initiates the wait operation but does not wait for its completion.', 'HTTP', 21),
(@playwright_server_id, 'playwright_assert_response', 'Wait for and validate a previously initiated HTTP response wait operation.', 'HTTP', 22),
(@playwright_server_id, 'playwright_custom_user_agent', 'Set a custom User Agent for the browser', 'Configuration', 23),
(@playwright_server_id, 'playwright_get_visible_text', 'Get the visible text content of the current page', 'Extraction', 24),
(@playwright_server_id, 'playwright_get_visible_html', 'Get the HTML content of the current page', 'Extraction', 25),
(@playwright_server_id, 'playwright_go_back', 'Navigate back in browser history', 'Navigation', 26),
(@playwright_server_id, 'playwright_go_forward', 'Navigate forward in browser history', 'Navigation', 27),
(@playwright_server_id, 'playwright_drag', 'Drag an element to a target location', 'Interaction', 28),
(@playwright_server_id, 'playwright_press_key', 'Press a keyboard key', 'Interaction', 29),
(@playwright_server_id, 'playwright_save_as_pdf', 'Save the current page as a PDF file', 'Export', 30),
(@playwright_server_id, 'playwright_click_and_switch_tab', 'Click an element and switch to newly opened tab', 'Navigation', 31);

-- Insert sample MCP Prompts
INSERT INTO mcp_prompts (mcp_server_id, prompt_name, prompt_description, prompt_category, display_order) VALUES
(@playwright_server_id, 'create_web_scraper', 'Generate a comprehensive web scraping script using Playwright', 'Code Generation', 1),
(@playwright_server_id, 'test_form_submission', 'Create automated tests for form submission workflows', 'Testing', 2),
(@playwright_server_id, 'performance_audit', 'Generate performance testing scripts for web applications', 'Performance', 3),
(@playwright_server_id, 'accessibility_check', 'Create accessibility testing automation scripts', 'Accessibility', 4);

-- Insert sample MCP Resources
INSERT INTO mcp_resources (mcp_server_id, resource_name, resource_description, resource_type, access_method, display_order) VALUES
(@playwright_server_id, 'browser_context', 'Isolated browser context for test execution', 'service', 'api', 1),
(@playwright_server_id, 'page_objects', 'Reusable page object models for common UI patterns', 'data', 'template', 2),
(@playwright_server_id, 'test_fixtures', 'Pre-configured test data and fixtures', 'file', 'uri', 3),
(@playwright_server_id, 'screenshot_storage', 'Storage service for captured screenshots and videos', 'service', 'api', 4);

-- Insert additional environment variables
INSERT INTO server_environment_variables (mcp_server_id, variable_name, is_required, description, data_type, default_value, security_level) VALUES
(@playwright_server_id, 'BROWSER_TYPE', 0, 'Browser to use for automation (chromium, firefox, webkit)', 'string', 'chromium', 'standard'),
(@playwright_server_id, 'HEADLESS_MODE', 0, 'Run browser in headless mode', 'boolean', 'true', 'standard'),
(@playwright_server_id, 'VIEWPORT_WIDTH', 0, 'Browser viewport width', 'number', '1280', 'standard'),
(@playwright_server_id, 'VIEWPORT_HEIGHT', 0, 'Browser viewport height', 'number', '720', 'standard'),
(@playwright_server_id, 'TIMEOUT_MS', 0, 'Default timeout for operations in milliseconds', 'number', '30000', 'standard'),
(@playwright_server_id, 'SCREENSHOT_PATH', 0, 'Directory path for saving screenshots', 'string', './screenshots', 'standard'),
(@playwright_server_id, 'VIDEO_PATH', 0, 'Directory path for saving videos', 'string', './videos', 'standard'),
    (v_playwright_server_id, 'SLOW_MO_MS', 0, 'Slow down operations by specified milliseconds', 'number', '0', 'standard');

    -- Update Playwright server with score information
    UPDATE mcp_servers 
    SET overall_score = 75.00,
        score_grade = 'B+',
        score_max_points = 100,
        score_earned_points = 75,
        score_last_updated = GETDATE()
    WHERE id = @playwright_server_id;

    -- Add score details for Playwright server
    INSERT INTO server_scores (mcp_server_id, criteria_id, score_value) VALUES
    (@playwright_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'has_readme'), 1),
    (@playwright_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'has_license'), 1),
    (@playwright_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'has_glama_json'), 0),
    (@playwright_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'server_inspectable'), 1),
    (@playwright_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'has_tools'), 1),
    (@playwright_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'no_vulnerabilities'), 1),
    (@playwright_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'claimed_by_author'), 0),
    (@playwright_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'has_related_servers'), 0);    -- Example of a complete second MCP server entry
    INSERT INTO mcp_servers (name, author, development_language, license, download_count, overview, server_slug, glama_url,
                            overall_score, score_grade, score_max_points, score_earned_points, score_last_updated) 
    VALUES (
        'GitHub MCP',
        'github-org',
        'TypeScript',
        'MIT',
        234567,
        'MCP server for GitHub API integration, repository management, and issue tracking.',
        'github-mcp',
        'https://glama.ai/mcp/servers/github-mcp',
        90.00,  -- 90% score
        'A-',   -- Grade
        100,    -- Max points possible
        90,     -- Points earned
        GETDATE()
    );DECLARE @github_server_id INT = SCOPE_IDENTITY();

-- Add score details for GitHub server
INSERT INTO server_scores (mcp_server_id, criteria_id, score_value) VALUES
(@github_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'has_readme'), 1),
(@github_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'has_license'), 1),
(@github_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'has_glama_json'), 1),
(@github_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'server_inspectable'), 1),
(@github_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'has_tools'), 1),
(@github_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'no_vulnerabilities'), 1),
(@github_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'claimed_by_author'), 1),
(@github_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'has_related_servers'), 0);

-- Add categories for GitHub server
INSERT INTO server_categories (mcp_server_id, category_id)
SELECT @github_server_id, id FROM categories WHERE category_name IN ('Developer Tools', 'Version Control', 'Cloud Platforms');

-- Add links for GitHub server
INSERT INTO server_links (mcp_server_id, link_type_id, url, link_text, is_primary)
VALUES 
(@github_server_id, (SELECT id FROM link_types WHERE type_name = 'npm'), 'https://www.npmjs.com/package/@github/mcp', 'NPM Package', 1),
(@github_server_id, (SELECT id FROM link_types WHERE type_name = 'github'), 'https://github.com/github/mcp-server', 'GitHub Repository', 1),
(@github_server_id, (SELECT id FROM link_types WHERE type_name = 'documentation'), 'https://docs.github.com/mcp', 'Documentation', 1);

-- Add sample tools for GitHub server
INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
(@github_server_id, 'create_repository', 'Create a new GitHub repository', 'Repository Management', 1),
(@github_server_id, 'list_issues', 'List issues from a repository', 'Issue Management', 2),
(@github_server_id, 'create_pull_request', 'Create a new pull request', 'Code Review', 3),
(@github_server_id, 'search_repositories', 'Search for repositories across GitHub', 'Search', 4),
(@github_server_id, 'get_user_profile', 'Get GitHub user profile information', 'User Management', 5);

-- Add environment variables for GitHub server
INSERT INTO server_environment_variables (mcp_server_id, variable_name, is_required, description, data_type, security_level) VALUES
(@github_server_id, 'GITHUB_TOKEN', 1, 'GitHub Personal Access Token for API authentication', 'string', 'secret'),
(@github_server_id, 'GITHUB_ORG', 0, 'Default GitHub organization for operations', 'string', 'standard'),
(@github_server_id, 'API_BASE_URL', 0, 'GitHub API base URL for enterprise instances', 'string', 'standard');

-- Add API endpoints
INSERT INTO mcp_api_endpoints (mcp_server_id, endpoint_url, http_method, endpoint_description, requires_auth, is_public) VALUES
(@github_server_id, 'https://glama.ai/api/mcp/v1/servers/github/mcp-server', 'GET', 'GitHub MCP server directory information', 0, 1),
(@github_server_id, 'https://api.github.com/repos/{owner}/{repo}', 'GET', 'Get repository information', 1, 1),
(@github_server_id, 'https://api.github.com/repos/{owner}/{repo}/issues', 'GET', 'List repository issues', 1, 1),
(@github_server_id, 'https://api.github.com/repos/{owner}/{repo}/pulls', 'POST', 'Create a pull request', 1, 1);
