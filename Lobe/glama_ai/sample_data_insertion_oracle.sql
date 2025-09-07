-- Sample Data Insertion Script for Glama.ai MCP Schema - Oracle Version
-- Created: September 5, 2025
-- Purpose: Insert comprehensive sample data for Playwright MCP server

-- This assumes the Playwright MCP server has already been inserted in the schema file
-- Get the server ID for reference
DECLARE
    v_playwright_server_id NUMBER;
    v_github_server_id NUMBER;
    v_category_id NUMBER;
    v_link_type_id NUMBER;
BEGIN
    -- Get Playwright server ID
    SELECT id INTO v_playwright_server_id FROM mcp_servers WHERE name = 'Playwright MCP';
    
    -- Insert score criteria if not already present
    BEGIN
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
    EXCEPTION
        WHEN OTHERS THEN
            NULL; -- Ignore if already exists
    END;
    
    -- Insert MCP Tools based on the provided list
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'start_codegen_session', 'Start a new code generation session to record Playwright actions', 'Code Generation', 1);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'end_codegen_session', 'End a code generation session and generate the test file', 'Code Generation', 2);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'get_codegen_session', 'Get information about a code generation session', 'Code Generation', 3);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'clear_codegen_session', 'Clear a code generation session without generating a test', 'Code Generation', 4);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_navigate', 'Navigate to a URL', 'Navigation', 5);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_screenshot', 'Take a screenshot of the current page or a specific element', 'Capture', 6);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_click', 'Click an element on the page', 'Interaction', 7);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_iframe_click', 'Click an element in an iframe on the page', 'Interaction', 8);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_iframe_fill', 'Fill an element in an iframe on the page', 'Interaction', 9);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_fill', 'Fill out an input field', 'Interaction', 10);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_select', 'Select an element on the page with Select tag', 'Interaction', 11);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_hover', 'Hover an element on the page', 'Interaction', 12);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_evaluate', 'Execute JavaScript in the browser console', 'Scripting', 13);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_console_logs', 'Retrieve console logs from the browser with filtering options', 'Debugging', 14);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_close', 'Close the browser and release all resources', 'Control', 15);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_get', 'Perform an HTTP GET request', 'HTTP', 16);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_post', 'Perform an HTTP POST request', 'HTTP', 17);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_put', 'Perform an HTTP PUT request', 'HTTP', 18);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_patch', 'Perform an HTTP PATCH request', 'HTTP', 19);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_delete', 'Perform an HTTP DELETE request', 'HTTP', 20);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_expect_response', 'Ask Playwright to start waiting for a HTTP response. This tool initiates the wait operation but does not wait for its completion.', 'HTTP', 21);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_assert_response', 'Wait for and validate a previously initiated HTTP response wait operation.', 'HTTP', 22);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_custom_user_agent', 'Set a custom User Agent for the browser', 'Configuration', 23);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_get_visible_text', 'Get the visible text content of the current page', 'Extraction', 24);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_get_visible_html', 'Get the HTML content of the current page', 'Extraction', 25);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_go_back', 'Navigate back in browser history', 'Navigation', 26);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_go_forward', 'Navigate forward in browser history', 'Navigation', 27);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_drag', 'Drag an element to a target location', 'Interaction', 28);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_press_key', 'Press a keyboard key', 'Interaction', 29);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_save_as_pdf', 'Save the current page as a PDF file', 'Export', 30);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_playwright_server_id, 'playwright_click_and_switch_tab', 'Click an element and switch to newly opened tab', 'Navigation', 31);

    -- Insert sample MCP Prompts (updated to match schema changes)
    INSERT INTO mcp_prompts (mcp_server_id, prompt_name, prompt_description) VALUES
    (v_playwright_server_id, 'create_web_scraper', 'Generate a comprehensive web scraping script using Playwright');
    INSERT INTO mcp_prompts (mcp_server_id, prompt_name, prompt_description) VALUES
    (v_playwright_server_id, 'test_form_submission', 'Create automated tests for form submission workflows');
    INSERT INTO mcp_prompts (mcp_server_id, prompt_name, prompt_description) VALUES
    (v_playwright_server_id, 'performance_audit', 'Generate performance testing scripts for web applications');
    INSERT INTO mcp_prompts (mcp_server_id, prompt_name, prompt_description) VALUES
    (v_playwright_server_id, 'accessibility_check', 'Create accessibility testing automation scripts');

    -- Insert sample MCP Resources (simplified)
    INSERT INTO mcp_resources (mcp_server_id, resource_name, resource_description) VALUES
    (v_playwright_server_id, 'browser_context', 'Isolated browser context for test execution');
    INSERT INTO mcp_resources (mcp_server_id, resource_name, resource_description) VALUES
    (v_playwright_server_id, 'page_objects', 'Reusable page object models for common UI patterns');
    INSERT INTO mcp_resources (mcp_server_id, resource_name, resource_description) VALUES
    (v_playwright_server_id, 'test_fixtures', 'Pre-configured test data and fixtures');
    INSERT INTO mcp_resources (mcp_server_id, resource_name, resource_description) VALUES
    (v_playwright_server_id, 'screenshot_storage', 'Storage service for captured screenshots and videos');

    -- Environment variables defined as global entries (no per-server mapping in this table)
    INSERT INTO server_environment_variables (variable_name, is_required, description) VALUES ('BROWSER_TYPE', FALSE, 'Browser to use for automation (chromium, firefox, webkit)');
    INSERT INTO server_environment_variables (variable_name, is_required, description) VALUES ('HEADLESS_MODE', FALSE, 'Run browser in headless mode');
    INSERT INTO server_environment_variables (variable_name, is_required, description) VALUES ('VIEWPORT_WIDTH', FALSE, 'Browser viewport width');
    INSERT INTO server_environment_variables (variable_name, is_required, description) VALUES ('VIEWPORT_HEIGHT', FALSE, 'Browser viewport height');
    INSERT INTO server_environment_variables (variable_name, is_required, description) VALUES ('TIMEOUT_MS', FALSE, 'Default timeout for operations in milliseconds');
    INSERT INTO server_environment_variables (variable_name, is_required, description) VALUES ('SCREENSHOT_PATH', FALSE, 'Directory path for saving screenshots');
    INSERT INTO server_environment_variables (variable_name, is_required, description) VALUES ('VIDEO_PATH', FALSE, 'Directory path for saving videos');
    INSERT INTO server_environment_variables (variable_name, is_required, description) VALUES ('SLOW_MO_MS', FALSE, 'Slow down operations by specified milliseconds');

    -- Update Playwright server with score information
    UPDATE mcp_servers 
    SET overall_score = 75.00,
        score_grade = 'B+',
        score_max_points = 100,
        score_earned_points = 75,
        score_last_updated = CURRENT_TIMESTAMP
    WHERE id = v_playwright_server_id;

    -- Add score details for Playwright server
    INSERT INTO server_scores (mcp_server_id, criteria_id, score_value) VALUES
    (v_playwright_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'has_readme'), 1);
    INSERT INTO server_scores (mcp_server_id, criteria_id, score_value) VALUES
    (v_playwright_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'has_license'), 1);
    INSERT INTO server_scores (mcp_server_id, criteria_id, score_value) VALUES
    (v_playwright_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'has_glama_json'), 0);
    INSERT INTO server_scores (mcp_server_id, criteria_id, score_value) VALUES
    (v_playwright_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'server_inspectable'), 1);
    INSERT INTO server_scores (mcp_server_id, criteria_id, score_value) VALUES
    (v_playwright_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'has_tools'), 1);
    INSERT INTO server_scores (mcp_server_id, criteria_id, score_value) VALUES
    (v_playwright_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'no_vulnerabilities'), 1);
    INSERT INTO server_scores (mcp_server_id, criteria_id, score_value) VALUES
    (v_playwright_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'claimed_by_author'), 0);
    INSERT INTO server_scores (mcp_server_id, criteria_id, score_value) VALUES
    (v_playwright_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'has_related_servers'), 0);

    -- Example of a complete second MCP server entry
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
        CURRENT_TIMESTAMP
    );

    -- Get the GitHub server ID
    SELECT id INTO v_github_server_id FROM mcp_servers WHERE name = 'GitHub MCP';

    -- Add score details for GitHub server
    INSERT INTO server_scores (mcp_server_id, criteria_id, score_value) VALUES
    (v_github_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'has_readme'), 1);
    INSERT INTO server_scores (mcp_server_id, criteria_id, score_value) VALUES
    (v_github_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'has_license'), 1);
    INSERT INTO server_scores (mcp_server_id, criteria_id, score_value) VALUES
    (v_github_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'has_glama_json'), 1);
    INSERT INTO server_scores (mcp_server_id, criteria_id, score_value) VALUES
    (v_github_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'server_inspectable'), 1);
    INSERT INTO server_scores (mcp_server_id, criteria_id, score_value) VALUES
    (v_github_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'has_tools'), 1);
    INSERT INTO server_scores (mcp_server_id, criteria_id, score_value) VALUES
    (v_github_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'no_vulnerabilities'), 1);
    INSERT INTO server_scores (mcp_server_id, criteria_id, score_value) VALUES
    (v_github_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'claimed_by_author'), 1);
    INSERT INTO server_scores (mcp_server_id, criteria_id, score_value) VALUES
    (v_github_server_id, (SELECT id FROM server_score_criteria WHERE criteria_name = 'has_related_servers'), 0);

    -- Add categories for GitHub server
    SELECT id INTO v_category_id FROM categories WHERE category_name = 'Developer Tools';
    INSERT INTO server_categories (mcp_server_id, category_id) VALUES (v_github_server_id, v_category_id);
    
    SELECT id INTO v_category_id FROM categories WHERE category_name = 'Version Control';
    INSERT INTO server_categories (mcp_server_id, category_id) VALUES (v_github_server_id, v_category_id);
    
    SELECT id INTO v_category_id FROM categories WHERE category_name = 'Cloud Platforms';
    INSERT INTO server_categories (mcp_server_id, category_id) VALUES (v_github_server_id, v_category_id);

    -- Add links for GitHub server
    SELECT id INTO v_link_type_id FROM link_types WHERE type_name = 'npm';
    INSERT INTO server_links (mcp_server_id, link_type_id, url, link_text, is_primary)
    VALUES (v_github_server_id, v_link_type_id, 'https://www.npmjs.com/package/@github/mcp', 'NPM Package', 1);
    
    SELECT id INTO v_link_type_id FROM link_types WHERE type_name = 'github';
    INSERT INTO server_links (mcp_server_id, link_type_id, url, link_text, is_primary)
    VALUES (v_github_server_id, v_link_type_id, 'https://github.com/github/mcp-server', 'GitHub Repository', 1);
    
    SELECT id INTO v_link_type_id FROM link_types WHERE type_name = 'documentation';
    INSERT INTO server_links (mcp_server_id, link_type_id, url, link_text, is_primary)
    VALUES (v_github_server_id, v_link_type_id, 'https://docs.github.com/mcp', 'Documentation', 1);

    -- Add sample tools for GitHub server
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_github_server_id, 'create_repository', 'Create a new GitHub repository', 'Repository Management', 1);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_github_server_id, 'list_issues', 'List issues from a repository', 'Issue Management', 2);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_github_server_id, 'create_pull_request', 'Create a new pull request', 'Code Review', 3);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_github_server_id, 'search_repositories', 'Search for repositories across GitHub', 'Search', 4);
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category, display_order) VALUES
    (v_github_server_id, 'get_user_profile', 'Get GitHub user profile information', 'User Management', 5);

    -- GitHub-related environment variables (global definitions)
    INSERT INTO server_environment_variables (variable_name, is_required, description) VALUES ('GITHUB_TOKEN', TRUE, 'GitHub Personal Access Token for API authentication');
    INSERT INTO server_environment_variables (variable_name, is_required, description) VALUES ('GITHUB_ORG', FALSE, 'Default GitHub organization for operations');
    INSERT INTO server_environment_variables (variable_name, is_required, description) VALUES ('API_BASE_URL', FALSE, 'GitHub API base URL for enterprise instances');

    -- Add API endpoints
    INSERT INTO mcp_api_endpoints (mcp_server_id, endpoint_url, http_method, endpoint_description, requires_auth, is_public) VALUES
    (v_github_server_id, 'https://glama.ai/api/mcp/v1/servers/github/mcp-server', 'GET', 'GitHub MCP server directory information', 0, 1);
    INSERT INTO mcp_api_endpoints (mcp_server_id, endpoint_url, http_method, endpoint_description, requires_auth, is_public) VALUES
    (v_github_server_id, 'https://api.github.com/repos/{owner}/{repo}', 'GET', 'Get repository information', 1, 1);
    INSERT INTO mcp_api_endpoints (mcp_server_id, endpoint_url, http_method, endpoint_description, requires_auth, is_public) VALUES
    (v_github_server_id, 'https://api.github.com/repos/{owner}/{repo}/issues', 'GET', 'List repository issues', 1, 1);
    INSERT INTO mcp_api_endpoints (mcp_server_id, endpoint_url, http_method, endpoint_description, requires_auth, is_public) VALUES
    (v_github_server_id, 'https://api.github.com/repos/{owner}/{repo}/pulls', 'POST', 'Create a pull request', 1, 1);

    -- Commit all changes
    COMMIT;
    
    -- Display success message
    DBMS_OUTPUT.PUT_LINE('Sample data for Oracle Glama.ai MCP schema inserted successfully!');
    DBMS_OUTPUT.PUT_LINE('Added ' || SQL%ROWCOUNT || ' total records across all tables.');
END;
/

-- Display final statistics
DECLARE
    v_servers NUMBER;
    v_tools NUMBER;
    v_prompts NUMBER;
    v_resources NUMBER;
    v_tags NUMBER;
    v_links NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_servers FROM mcp_servers;
    SELECT COUNT(*) INTO v_tools FROM mcp_tools;
    SELECT COUNT(*) INTO v_prompts FROM mcp_prompts;
    SELECT COUNT(*) INTO v_resources FROM mcp_resources;
    SELECT COUNT(*) INTO v_tags FROM tags;
    SELECT COUNT(*) INTO v_links FROM server_links;
    
    DBMS_OUTPUT.PUT_LINE('=== Final Database Statistics ===');
    DBMS_OUTPUT.PUT_LINE('Total Servers: ' || v_servers);
    DBMS_OUTPUT.PUT_LINE('Total Tools: ' || v_tools);
    DBMS_OUTPUT.PUT_LINE('Total Prompts: ' || v_prompts);
    DBMS_OUTPUT.PUT_LINE('Total Resources: ' || v_resources);
    DBMS_OUTPUT.PUT_LINE('Total Tags: ' || v_tags);
    DBMS_OUTPUT.PUT_LINE('Total Links: ' || v_links);
END;
/
