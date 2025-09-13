-- Created by Franz Phillip G. Domingo 
-- Created: September 5, 2025
-- Last Updated: September 8, 2025
-- Purepose: Sample data for mcp_endpoints (MCP Server Endpoints)

-- Category inserts moved from schema file
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

-- Commit the changes


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

-- Sample data for mcp_reviews (MCP Server Reviews)
-- Note: Uses CLOB for review_content, and assumes mcp_server_id 1 exists
INSERT INTO mcp_reviews (mcp_server_id, review_content, created_at, updated_at)
VALUES (
    1,
    'This is a sample review for demonstration purposes. The review content can be as long as needed, since CLOB is used.',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);
-- Sample data for mcp_endpoints (MCP Server Endpoints)
-- Note: Uses CLOB for endpoint_content, and assumes mcp_server_id 1 exists
INSERT INTO mcp_endpoints (mcp_server_id, endpoint_content, created_at, updated_at)
VALUES (
    1,
    'This is a sample endpoint content for demonstration purposes. The endpoint content can be as long as needed, since CLOB is used.',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);
-- Add links for the Playwright server
DECLARE
    v_server_id NUMBER;
    v_link_type_id NUMBER;
BEGIN
    -- Get the server ID
    SELECT id INTO v_server_id FROM mcp_servers WHERE name = 'Playwright MCP';
    
    -- Add npm link
    INSERT INTO mcp_links (mcp_server_id, link_type, url, is_primary)
    VALUES (v_server_id, 'npm', 'https://www.npmjs.com/package/@playwright/mcp', 1);
    -- Add github link
    INSERT INTO mcp_links (mcp_server_id, link_type, url, is_primary)
    VALUES (v_server_id, 'github', 'https://github.com/lewisvoncken/playwright-mcp', 1);
END;
/

-- Add environment variable example
DECLARE
    v_server_id NUMBER;
BEGIN
    -- Get the server ID
    SELECT id INTO v_server_id FROM mcp_servers WHERE name = 'Playwright MCP';

    -- Add environment variable with proper server mapping
    INSERT INTO mcp_server_configuration (mcp_server_id, variable_name, is_required, description)
    VALUES (v_server_id, 'GITHUB_PERSONAL_ACCESS_TOKEN', 1,
           'GitHub Personal Access Token with appropriate permissions (repo scope for full control, public_repo for public repositories only)');
END;
/


-- Add API endpoint example (commented out - table doesn't exist in current schema)
DECLARE
    v_server_id NUMBER;
BEGIN
    -- Get the server ID
    SELECT id INTO v_server_id FROM mcp_servers WHERE name = 'Playwright MCP';
    
    -- INSERT INTO mcp_api_endpoints (mcp_server_id, endpoint_url, http_method, endpoint_description, is_public)
    -- VALUES (v_server_id, 'https://glama.ai/api/mcp/v1/servers/glifxyz/glif-mcp-server', 'GET', 
    --        'MCP directory API endpoint for server information', 1);
END;
/
-- This block now includes server insertions that were assumed to exist elsewhere
-- Get the server ID for reference
DECLARE
    v_playwright_server_id NUMBER;
    v_github_server_id NUMBER;
    v_category_id NUMBER;
    v_link_type_id NUMBER;
    v_score_summary_id NUMBER;
BEGIN
    -- Insert Playwright MCP server first
    INSERT INTO mcp_servers (name, author, development_language, license, download_count, overview, server_slug, glama_url, created_at, updated_at, scraped_at, is_active)
    VALUES (
        'Playwright MCP',
        'playwright-community',
        'TypeScript',
        'MIT',
        156789,
        'MCP server for browser automation using Playwright. Provides tools for web scraping, testing, and automation.',
        'playwright-mcp',
        'https://glama.ai/mcp/servers/playwright-mcp',
        CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1
    );
    
    -- Get Playwright server ID
    SELECT id INTO v_playwright_server_id FROM mcp_servers WHERE name = 'Playwright MCP';

    -- Add score summary for Playwright server
    INSERT INTO score_summary (mcp_server_id, security, license, quality)
    VALUES (v_playwright_server_id, 'A', 'A', 'A');
    SELECT id INTO v_score_summary_id FROM score_summary WHERE mcp_server_id = v_playwright_server_id;

    -- Add score details for Playwright server
    INSERT INTO mcp_scores (mcp_server_id, score_summary_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_playwright_server_id, v_score_summary_id, 'has_readme', 'Repository has a README.md file', 1, 10);
    INSERT INTO mcp_scores (mcp_server_id, score_summary_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_playwright_server_id, v_score_summary_id, 'has_license', 'The repository has a LICENSE file', 1, 10);
    INSERT INTO mcp_scores (mcp_server_id, score_summary_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_playwright_server_id, v_score_summary_id, 'has_glama_json', 'Repository has a valid glama.json configuration file', 1, 15);
    INSERT INTO mcp_scores (mcp_server_id, score_summary_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_playwright_server_id, v_score_summary_id, 'server_inspectable', 'Server can be inspected through server inspector', 1, 15);
    INSERT INTO mcp_scores (mcp_server_id, score_summary_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_playwright_server_id, v_score_summary_id, 'has_tools', 'Server has at least one tool defined in schema', 1, 20);
    INSERT INTO mcp_scores (mcp_server_id, score_summary_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_playwright_server_id, v_score_summary_id, 'no_vulnerabilities', 'Server has no known security vulnerabilities', 1, 15);
    INSERT INTO mcp_scores (mcp_server_id, score_summary_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_playwright_server_id, v_score_summary_id, 'claimed_by_author', 'Server is claimed and verified by the original author', 1, 10);
    INSERT INTO mcp_scores (mcp_server_id, score_summary_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_playwright_server_id, v_score_summary_id, 'has_related_servers', 'Server has user-submitted related MCP servers for discoverability', 1, 5);
    

    
    -- Insert MCP Tools based on the provided list (display_order removed)
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'start_codegen_session', 'Start a new code generation session to record Playwright actions', 'Code Generation');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'end_codegen_session', 'End a code generation session and generate the test file', 'Code Generation');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'get_codegen_session', 'Get information about a code generation session', 'Code Generation');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'clear_codegen_session', 'Clear a code generation session without generating a test', 'Code Generation');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_navigate', 'Navigate to a URL', 'Navigation');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_screenshot', 'Take a screenshot of the current page or a specific element', 'Capture');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_click', 'Click an element on the page', 'Interaction');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_iframe_click', 'Click an element in an iframe on the page', 'Interaction');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_iframe_fill', 'Fill an element in an iframe on the page', 'Interaction');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_fill', 'Fill out an input field', 'Interaction');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_select', 'Select an element on the page with Select tag', 'Interaction');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_hover', 'Hover an element on the page', 'Interaction');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_evaluate', 'Execute JavaScript in the browser console', 'Scripting');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_console_logs', 'Retrieve console logs from the browser with filtering options', 'Debugging');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_close', 'Close the browser and release all resources', 'Control');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_get', 'Perform an HTTP GET request', 'HTTP');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_post', 'Perform an HTTP POST request', 'HTTP');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_put', 'Perform an HTTP PUT request', 'HTTP');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_patch', 'Perform an HTTP PATCH request', 'HTTP');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_delete', 'Perform an HTTP DELETE request', 'HTTP');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_expect_response', 'Ask Playwright to start waiting for a HTTP response. This tool initiates the wait operation but does not wait for its completion.', 'HTTP');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_assert_response', 'Wait for and validate a previously initiated HTTP response wait operation.', 'HTTP');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_custom_user_agent', 'Set a custom User Agent for the browser', 'Configuration');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_get_visible_text', 'Get the visible text content of the current page', 'Extraction');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_get_visible_html', 'Get the HTML content of the current page', 'Extraction');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_go_back', 'Navigate back in browser history', 'Navigation');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_go_forward', 'Navigate forward in browser history', 'Navigation');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_drag', 'Drag an element to a target location', 'Interaction');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_press_key', 'Press a keyboard key', 'Interaction');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_save_as_pdf', 'Save the current page as a PDF file', 'Export');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_playwright_server_id, 'playwright_click_and_switch_tab', 'Click an element and switch to newly opened tab', 'Navigation');

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

    -- MCP Server Configuration for Playwright MCP server with proper foreign key mapping
    INSERT INTO mcp_server_configuration (mcp_server_id, variable_name, is_required, description) VALUES (v_playwright_server_id, 'PLAYWRIGHT_BROWSER', 0, 'Browser engine to use for Playwright automation (chromium, firefox, webkit). Defaults to chromium.');
    INSERT INTO mcp_server_configuration (mcp_server_id, variable_name, is_required, description) VALUES (v_playwright_server_id, 'PLAYWRIGHT_HEADLESS', 0, 'Run Playwright browser in headless mode (true/false). Defaults to true.');
    INSERT INTO mcp_server_configuration (mcp_server_id, variable_name, is_required, description) VALUES (v_playwright_server_id, 'PLAYWRIGHT_VIEWPORT_WIDTH', 0, 'Default viewport width for Playwright browser sessions. Defaults to 1280.');
    INSERT INTO mcp_server_configuration (mcp_server_id, variable_name, is_required, description) VALUES (v_playwright_server_id, 'PLAYWRIGHT_VIEWPORT_HEIGHT', 0, 'Default viewport height for Playwright browser sessions. Defaults to 720.');
    INSERT INTO mcp_server_configuration (mcp_server_id, variable_name, is_required, description) VALUES (v_playwright_server_id, 'PLAYWRIGHT_TIMEOUT', 0, 'Default timeout for Playwright operations in milliseconds. Defaults to 30000.');
    INSERT INTO mcp_server_configuration (mcp_server_id, variable_name, is_required, description) VALUES (v_playwright_server_id, 'PLAYWRIGHT_SCREENSHOT_DIR', 0, 'Directory path for saving Playwright screenshots. Defaults to ./screenshots');
    INSERT INTO mcp_server_configuration (mcp_server_id, variable_name, is_required, description) VALUES (v_playwright_server_id, 'PLAYWRIGHT_VIDEO_DIR', 0, 'Directory path for saving Playwright recorded videos. Defaults to ./videos');
    INSERT INTO mcp_server_configuration (mcp_server_id, variable_name, is_required, description) VALUES (v_playwright_server_id, 'PLAYWRIGHT_SLOW_MO', 0, 'Slow down Playwright operations by specified milliseconds for debugging. Defaults to 0.');
    INSERT INTO mcp_server_configuration (mcp_server_id, variable_name, is_required, description) VALUES (v_playwright_server_id, 'PLAYWRIGHT_USER_AGENT', 0, 'Custom user agent string for Playwright browser sessions.');
    INSERT INTO mcp_server_configuration (mcp_server_id, variable_name, is_required, description) VALUES (v_playwright_server_id, 'PLAYWRIGHT_PROXY_SERVER', 0, 'Proxy server URL for Playwright browser sessions (e.g., http://proxy.example.com:8080).');
    INSERT INTO mcp_server_configuration (mcp_server_id, variable_name, is_required, description) VALUES (v_playwright_server_id, 'PLAYWRIGHT_LOCALE', 0, 'Locale for Playwright browser sessions (e.g., en-US, fr-FR). Defaults to en-US.');
    INSERT INTO mcp_server_configuration (mcp_server_id, variable_name, is_required, description) VALUES (v_playwright_server_id, 'PLAYWRIGHT_TIMEZONE', 0, 'Timezone for Playwright browser sessions (e.g., America/New_York). Defaults to system timezone.');



    -- Add score summary for Playwright server (second block)
    INSERT INTO score_summary (mcp_server_id, security, license, quality)
    VALUES (v_playwright_server_id, 'A', 'A', 'F');
    SELECT id INTO v_score_summary_id FROM score_summary WHERE mcp_server_id = v_playwright_server_id;

    -- Add score details for Playwright server (new structure)
    INSERT INTO mcp_scores (mcp_server_id, score_summary_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_playwright_server_id, v_score_summary_id, 'has_readme', 'Repository has a README.md file', 1, 10);
    INSERT INTO mcp_scores (mcp_server_id, score_summary_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_playwright_server_id, v_score_summary_id, 'has_license', 'The repository has a LICENSE file', 1, 10);
    INSERT INTO mcp_scores (mcp_server_id, score_summary_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_playwright_server_id, v_score_summary_id, 'has_glama_json', 'Repository has a valid glama.json configuration file', 0, 15);
    INSERT INTO mcp_scores (mcp_server_id, score_summary_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_playwright_server_id, v_score_summary_id, 'server_inspectable', 'Server can be inspected through server inspector', 1, 15);
    INSERT INTO mcp_scores (mcp_server_id, score_summary_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_playwright_server_id, v_score_summary_id, 'has_tools', 'Server has at least one tool defined in schema', 1, 20);
    INSERT INTO mcp_scores (mcp_server_id, score_summary_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_playwright_server_id, v_score_summary_id, 'no_vulnerabilities', 'Server has no known security vulnerabilities', 1, 15);
    INSERT INTO mcp_scores (mcp_server_id, score_summary_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_playwright_server_id, v_score_summary_id, 'claimed_by_author', 'Server is claimed and verified by the original author', 0, 10);
    INSERT INTO mcp_scores (mcp_server_id, score_summary_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_playwright_server_id, v_score_summary_id, 'has_related_servers', 'Server has user-submitted related MCP servers for discoverability', 0, 5);

    -- Example of a complete second MCP server entry (score fields removed)
    INSERT INTO mcp_servers (name, author, development_language, license, download_count, overview, server_slug, glama_url, created_at, updated_at, scraped_at, is_active)
    VALUES (
        'GitHub MCP',
        'github-org',
        'TypeScript',
        'MIT',
        234567,
        'MCP server for GitHub API integration, repository management, and issue tracking.',
        'github-mcp',
        'https://glama.ai/mcp/servers/github-mcp',
        CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1
    );

    -- Get the GitHub server ID
    SELECT id INTO v_github_server_id FROM mcp_servers WHERE name = 'GitHub MCP';

    -- Add score details for GitHub server (new structure)
    INSERT INTO mcp_scores (mcp_server_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_github_server_id, 'has_readme', 'Repository has a README.md file', 1, 10);
    INSERT INTO mcp_scores (mcp_server_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_github_server_id, 'has_license', 'The repository has a LICENSE file', 1, 10);
    INSERT INTO mcp_scores (mcp_server_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_github_server_id, 'has_glama_json', 'Repository has a valid glama.json configuration file', 1, 15);
    INSERT INTO mcp_scores (mcp_server_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_github_server_id, 'server_inspectable', 'Server can be inspected through server inspector', 1, 15);
    INSERT INTO mcp_scores (mcp_server_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_github_server_id, 'has_tools', 'Server has at least one tool defined in schema', 1, 20);
    INSERT INTO mcp_scores (mcp_server_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_github_server_id, 'no_vulnerabilities', 'Server has no known security vulnerabilities', 1, 15);
    INSERT INTO mcp_scores (mcp_server_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_github_server_id, 'claimed_by_author', 'Server is claimed and verified by the original author', 1, 10);
    INSERT INTO mcp_scores (mcp_server_id, criteria_name, criteria_description, score_value, max_points) VALUES
        (v_github_server_id, 'has_related_servers', 'Server has user-submitted related MCP servers for discoverability', 0, 5);

    -- Add categories for GitHub server
    SELECT id INTO v_category_id FROM categories WHERE category_name = 'Developer Tools';
    INSERT INTO server_categories (mcp_server_id, category_id) VALUES (v_github_server_id, v_category_id);
    
    SELECT id INTO v_category_id FROM categories WHERE category_name = 'Version Control';
    INSERT INTO server_categories (mcp_server_id, category_id) VALUES (v_github_server_id, v_category_id);
    
    SELECT id INTO v_category_id FROM categories WHERE category_name = 'Cloud Platforms';
    INSERT INTO server_categories (mcp_server_id, category_id) VALUES (v_github_server_id, v_category_id);

    -- Add links for GitHub server
    INSERT INTO mcp_links (mcp_server_id, link_type, url, is_primary)
    VALUES (v_github_server_id, 'npm', 'https://www.npmjs.com/package/@github/mcp', 1);
    INSERT INTO mcp_links (mcp_server_id, link_type, url, is_primary)
    VALUES (v_github_server_id, 'github', 'https://github.com/github/mcp-server', 1);
    INSERT INTO mcp_links (mcp_server_id, link_type, url, is_primary)
    VALUES (v_github_server_id, 'documentation', 'https://docs.github.com/mcp', 1);

    -- Add sample tools for GitHub server
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_github_server_id, 'create_repository', 'Create a new GitHub repository', 'Repository Management');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_github_server_id, 'list_issues', 'List issues from a repository', 'Issue Management');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_github_server_id, 'create_pull_request', 'Create a new pull request', 'Code Review');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_github_server_id, 'search_repositories', 'Search for repositories across GitHub', 'Search');
    INSERT INTO mcp_tools (mcp_server_id, tool_name, tool_description, tool_category) VALUES
    (v_github_server_id, 'get_user_profile', 'Get GitHub user profile information', 'User Management');

    -- GitHub-related MCP server configuration with proper foreign key mapping
    INSERT INTO mcp_server_configuration (mcp_server_id, variable_name, is_required, description) VALUES (v_github_server_id, 'GITHUB_TOKEN', 1, 'GitHub Personal Access Token for API authentication');
    INSERT INTO mcp_server_configuration (mcp_server_id, variable_name, is_required, description) VALUES (v_github_server_id, 'GITHUB_ORG', 0, 'Default GitHub organization for operations');
    INSERT INTO mcp_server_configuration (mcp_server_id, variable_name, is_required, description) VALUES (v_github_server_id, 'API_BASE_URL', 0, 'GitHub API base URL for enterprise instances');

    -- Insert sample related servers data
    -- Note: These relationships show how servers can be semantically related or user-submitted alternatives
    
    -- Semantically related servers: Playwright and GitHub are both developer tools
    INSERT INTO mcp_related_servers (source_server_id, related_server_id, relationship_type, description, created_by)
    VALUES (v_playwright_server_id, v_github_server_id, 'Semantically Related Servers',
            'Both servers are developer tools commonly used together in CI/CD workflows', 'system');

    -- Reverse relationship
    INSERT INTO mcp_related_servers (source_server_id, related_server_id, relationship_type, description, created_by)
    VALUES (v_github_server_id, v_playwright_server_id, 'Semantically Related Servers',
            'Both servers are developer tools commonly used together in CI/CD workflows', 'system');

    -- Example user-submitted alternative (hypothetical case showing different approach)
    -- This would represent a user suggesting an alternative testing approach
    INSERT INTO mcp_related_servers (source_server_id, related_server_id, relationship_type, description, created_by)
    VALUES (v_playwright_server_id, v_github_server_id, 'User-submitted Alternatives',
            'Alternative approach: Use GitHub Actions for automated testing instead of direct browser automation', 'user:developer123');

    -- Show how the system can track who suggested relationships and their reasoning
    INSERT INTO mcp_related_servers (source_server_id, related_server_id, relationship_type, description, created_by)
    VALUES (v_github_server_id, v_playwright_server_id, 'User-submitted Alternatives',
            'Great combination for end-to-end testing: GitHub for repo management, Playwright for browser testing', 'user:qa_engineer_456');

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
    v_related_servers NUMBER;
    v_links NUMBER;
    v_categories NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_servers FROM mcp_servers;
    SELECT COUNT(*) INTO v_tools FROM mcp_tools;
    SELECT COUNT(*) INTO v_prompts FROM mcp_prompts;
    SELECT COUNT(*) INTO v_resources FROM mcp_resources;
    SELECT COUNT(*) INTO v_related_servers FROM mcp_related_servers;
    SELECT COUNT(*) INTO v_links FROM mcp_links;
    SELECT COUNT(*) INTO v_categories FROM categories;
    
    DBMS_OUTPUT.PUT_LINE('=== Final Database Statistics ===');
    DBMS_OUTPUT.PUT_LINE('Total Servers: ' || v_servers);
    DBMS_OUTPUT.PUT_LINE('Total Tools: ' || v_tools);
    DBMS_OUTPUT.PUT_LINE('Total Prompts: ' || v_prompts);
    DBMS_OUTPUT.PUT_LINE('Total Resources: ' || v_resources);
    DBMS_OUTPUT.PUT_LINE('Total Related Servers: ' || v_related_servers);
    DBMS_OUTPUT.PUT_LINE('Total Links: ' || v_links);
    DBMS_OUTPUT.PUT_LINE('Total Categories: ' || v_categories);
END;
/
