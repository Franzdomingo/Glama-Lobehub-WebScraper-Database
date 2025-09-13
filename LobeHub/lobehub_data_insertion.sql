-- LobeHub MCP Server Data Insertion Script
-- Sample data for all tables in the LobeHub MCP schema

-- Sample MCP Server data
INSERT INTO mcp_server (id, name, author, development_language, license, download_count, overview, short_description, server_slug, lobehub_url) VALUES
(1, 'Playwright MCP Server', 'LobeHub', 'TypeScript', 'MIT', 15000, 'A comprehensive MCP server for browser automation using Playwright. Provides tools for web page interaction, screenshot capture, form filling, and navigation.', 'Browser automation MCP server with Playwright integration', 'playwright-mcp', 'https://lobehub.com/discover/assistant/playwright-mcp'),
(2, 'Obsidian MCP Server', 'newtype-01', 'TypeScript', 'MIT', 8500, 'A comprehensive MCP server for Obsidian vault management and note operations. Provides tools for note creation, reading, searching, and vault management with comprehensive features and high-quality user experience.', 'Obsidian vault management MCP server with comprehensive features', 'newtype-01-obsidian-mcp', 'https://lobehub.com/mcp/newtype-01-obsidian-mcp');

-- Sample dependencies data
INSERT INTO mcp_server_dependencies (id, mcp_server_id, dependency_type, dependency_name, version_requirement) VALUES
(1, 1, 'system', 'nodejs', '>=18');

-- Sample installation methods for nodejs
INSERT INTO mcp_server_installation_methods (id, dependency_id, platform, installation_command) VALUES
(1, 1, 'macos', 'brew install node@18');

INSERT INTO mcp_server_installation_methods (id, dependency_id, platform, installation_url) VALUES
(2, 1, 'manual', 'https://nodejs.org/en/download/'),
(3, 1, 'windows', 'https://nodejs.org/en/download/');

INSERT INTO mcp_server_installation_methods (id, dependency_id, platform, installation_command) VALUES
(4, 1, 'linux_debian', 'sudo apt install nodejs npm');

-- Sample links data
INSERT INTO mcp_server_links (id, mcp_server_id, link_type, is_primary, url) VALUES
(1, 1, 'github', 1, 'https://github.com/lobehub/mcp-playwright'),
(2, 1, 'npm', 0, 'https://www.npmjs.com/package/@lobehub/mcp-playwright'),
(3, 1, 'documentation', 0, 'https://docs.lobehub.com/mcp/playwright');

-- Sample tools data for browser automation MCP server
INSERT INTO mcp_server_tools (id, mcp_server_id, tool_name, tool_description) VALUES
(1, 1, 'browser_close', 'Close the page'),
(2, 1, 'browser_resize', 'Resize the browser window'),
(3, 1, 'browser_console_messages', 'Returns all console messages'),
(4, 1, 'browser_handle_dialog', 'Handle a dialog'),
(5, 1, 'browser_evaluate', 'Evaluate JavaScript expression on page or element'),
(6, 1, 'browser_file_upload', 'Upload one or multiple files'),
(7, 1, 'browser_fill_form', 'Fill multiple form fields'),
(8, 1, 'browser_install', 'Install the browser specified in the config'),
(9, 1, 'browser_press_key', 'Press a key on the keyboard'),
(10, 1, 'browser_type', 'Type text into editable element'),
(11, 1, 'browser_navigate', 'Navigate to a URL'),
(12, 1, 'browser_navigate_back', 'Go back to the previous page'),
(13, 1, 'browser_network_requests', 'Returns all network requests since loading the page'),
(14, 1, 'browser_take_screenshot', 'Take a screenshot of the current page'),
(15, 1, 'browser_snapshot', 'Capture accessibility snapshot of the current page'),
(16, 1, 'browser_click', 'Perform click on a web page'),
(17, 1, 'browser_drag', 'Perform drag and drop between two elements'),
(18, 1, 'browser_hover', 'Hover over element on page'),
(19, 1, 'browser_select_option', 'Select an option in a dropdown'),
(20, 1, 'browser_tabs', 'List, create, close, or select a browser tab'),
(21, 1, 'browser_wait_for', 'Wait for text to appear or disappear or a specified time to pass');

-- Sample tool parameters
INSERT INTO mcp_server_tool_parameters (id, tool_id, parameter_name, parameter_type, is_required, parameter_description) VALUES
-- browser_resize parameters
(1, 2, 'width', 'number', 1, 'Width of the browser window'),
(2, 2, 'height', 'number', 1, 'Height of the browser window'),
-- browser_handle_dialog parameters
(3, 4, 'accept', 'boolean', 1, 'Whether to accept the dialog'),
(4, 4, 'promptText', 'string', 0, 'The text of the prompt in case of a prompt dialog'),
-- browser_evaluate parameters
(5, 5, 'ref', 'string', 0, 'Exact target element reference from the page snapshot'),
(6, 5, 'element', 'string', 0, 'Human-readable element description used to obtain permission to interact with the element'),
(7, 5, 'function', 'string', 1, '() => { /* code */ } or (element) => { /* code */ } when element is provided'),
-- browser_file_upload parameters
(8, 6, 'paths', 'array', 1, 'The absolute paths to the files to upload. Can be a single file or multiple files'),
-- browser_fill_form parameters
(9, 7, 'fields', 'array', 1, 'Fields to fill in'),
-- browser_press_key parameters
(10, 9, 'key', 'string', 1, 'Name of the key to press or a character to generate, such as ArrowLeft or a'),
-- browser_type parameters
(11, 10, 'ref', 'string', 1, 'Exact target element reference from the page snapshot'),
(12, 10, 'text', 'string', 1, 'Text to type into the element'),
(13, 10, 'slowly', 'boolean', 0, 'Whether to type one character at a time'),
(14, 10, 'submit', 'boolean', 0, 'Whether to submit entered text (press Enter after)'),
(15, 10, 'element', 'string', 1, 'Human-readable element description used to obtain permission to interact with the element'),
-- browser_navigate parameters
(16, 11, 'url', 'string', 1, 'The URL to navigate to'),
-- browser_take_screenshot parameters
(17, 14, 'ref', 'string', 0, 'Exact target element reference from the page snapshot'),
(18, 14, 'type', 'string', 0, 'Image format for the screenshot. Default is png'),
(19, 14, 'element', 'string', 0, 'Human-readable element description used to obtain permission to screenshot the element'),
(20, 14, 'filename', 'string', 0, 'File name to save the screenshot to'),
(21, 14, 'fullPage', 'boolean', 0, 'When true, takes a screenshot of the full scrollable page'),
-- browser_click parameters
(22, 16, 'ref', 'string', 1, 'Exact target element reference from the page snapshot'),
(23, 16, 'button', 'string', 0, 'Button to click, defaults to left'),
(24, 16, 'element', 'string', 1, 'Human-readable element description used to obtain permission to interact with the element'),
(25, 16, 'modifiers', 'array', 0, 'Modifier keys to press'),
(26, 16, 'doubleClick', 'boolean', 0, 'Whether to perform a double click instead of a single click'),
-- browser_drag parameters
(27, 17, 'endRef', 'string', 1, 'Exact target element reference from the page snapshot'),
(28, 17, 'startRef', 'string', 1, 'Exact source element reference from the page snapshot'),
(29, 17, 'endElement', 'string', 1, 'Human-readable target element description'),
(30, 17, 'startElement', 'string', 1, 'Human-readable source element description'),
-- browser_hover parameters
(31, 18, 'ref', 'string', 1, 'Exact target element reference from the page snapshot'),
(32, 18, 'element', 'string', 1, 'Human-readable element description used to obtain permission to interact with the element'),
-- browser_select_option parameters
(33, 19, 'ref', 'string', 1, 'Exact target element reference from the page snapshot'),
(34, 19, 'values', 'array', 1, 'Array of values to select in the dropdown'),
(35, 19, 'element', 'string', 1, 'Human-readable element description used to obtain permission to interact with the element'),
-- browser_tabs parameters
(36, 20, 'index', 'number', 0, 'Tab index, used for close/select'),
(37, 20, 'action', 'string', 1, 'Operation to perform'),
-- browser_wait_for parameters
(38, 21, 'text', 'string', 0, 'The text to wait for'),
(39, 21, 'time', 'number', 0, 'The time to wait in seconds'),
(40, 21, 'textGone', 'string', 0, 'The text to wait for to disappear');

-- Sample prompt data
--no data found for playwright mcp
INSERT INTO mcp_server_prompts (id, mcp_server_id, prompt_name, prompt_description) VALUES
(1, 1, 'sample_prompt', 'sample_description');

-- Sample resource data
-- from obsidian mcp no data found for playwright mcp
INSERT INTO mcp_server_resources (id, mcp_server_id, resource_name, mime_type, uri, resource_description) VALUES
(1, 1, 'CHANGELOG.md', 'text/markdown', 'obsidian://node_modules%2Fwhich%2FCHANGELOG.md', 'Markdown note: node_modules/which/CHANGELOG.md'),
(2, 1, 'README.md', 'text/markdown', 'obsidian://node_modules%2Fwhich%2FREADME.md', 'Markdown note: node_modules/which/README.md'),
(3, 2, 'Vault Notes', 'text/markdown', 'obsidian://vault', 'Access to Obsidian vault notes and documents'),
(4, 2, 'Note Templates', 'text/markdown', 'obsidian://templates', 'Obsidian note templates and configurations');

-- Obsidian MCP Server Dependencies
INSERT INTO mcp_server_dependencies (id, mcp_server_id, dependency_type, dependency_name, version_requirement) VALUES
(2, 2, 'system', 'nodejs', '>=18'),
(3, 2, 'application', 'obsidian', '>=1.0.0'),
(4, 2, 'npm', '@newtype-01/obsidian-mcp', 'latest');

-- Obsidian MCP Server Installation Methods (5 methods based on scraped data)
-- NodeJS installation for Obsidian MCP
INSERT INTO mcp_server_installation_methods (id, dependency_id, platform, installation_command) VALUES
(5, 2, 'macos', 'brew install node@18'),
(6, 2, 'linux_debian', 'sudo apt install nodejs npm');

INSERT INTO mcp_server_installation_methods (id, dependency_id, platform, installation_url) VALUES
(7, 2, 'manual', 'https://nodejs.org/en/download/'),
(8, 2, 'windows', 'https://nodejs.org/en/download/');

-- Obsidian MCP package installation methods
INSERT INTO mcp_server_installation_methods (id, dependency_id, platform, installation_command) VALUES
(9, 4, 'npm', 'npm install @newtype-01/obsidian-mcp'),
(10, 4, 'pnpm', 'pnpm install @newtype-01/obsidian-mcp'),
(11, 4, 'yarn', 'yarn add @newtype-01/obsidian-mcp');

INSERT INTO mcp_server_installation_methods (id, dependency_id, platform, installation_url) VALUES
(12, 4, 'manual', 'https://github.com/newtype-01/obsidian-mcp');

-- Obsidian MCP Server Links
INSERT INTO mcp_server_links (id, mcp_server_id, link_type, is_primary, url) VALUES
(4, 2, 'github', 1, 'https://github.com/newtype-01/obsidian-mcp'),
(5, 2, 'npm', 0, 'https://www.npmjs.com/package/@newtype-01/obsidian-mcp'),
(6, 2, 'lobehub', 0, 'https://lobehub.com/mcp/newtype-01-obsidian-mcp');

-- Obsidian MCP Server Tools (8 tools based on scraped data)
INSERT INTO mcp_server_tools (id, mcp_server_id, tool_name, tool_description) VALUES
(22, 2, 'create_note', 'Create a new note in the Obsidian vault'),
(23, 2, 'read_note', 'Read the contents of an existing note'),
(24, 2, 'update_note', 'Update or modify an existing note'),
(25, 2, 'delete_note', 'Delete a note from the vault'),
(26, 2, 'search_notes', 'Search for notes within the vault'),
(27, 2, 'list_notes', 'List all notes in the vault'),
(28, 2, 'get_vault_info', 'Get information about the Obsidian vault'),
(29, 2, 'manage_tags', 'Manage tags within the Obsidian vault');

-- Obsidian MCP Server Prompts
INSERT INTO mcp_server_prompts (id, mcp_server_id, prompt_name, prompt_description) VALUES
(2, 2, 'note_creation_prompt', 'Prompt for creating structured notes in Obsidian'),
(3, 2, 'vault_organization_prompt', 'Prompt for organizing and structuring vault content');

-- Obsidian MCP Server Score Data
INSERT INTO mcp_server_scores (id, mcp_server_id, overall_score, grade, grade_percentage, badge_status, validation_status, installation_methods_count, tools_count, resources_count, has_readme, has_license, has_prompts, is_claimed_by_owner) VALUES
(1, 2, 80, 'A', 80.00, 'Excellent Plugin', 'Validated', 5, 8, 2, 1, 1, 1, 0);

-- Obsidian MCP Server Score Details
INSERT INTO mcp_server_score_details (id, score_id, criteria_name, criteria_description, is_met, points_awarded, max_points) VALUES
(1, 1, 'Validated', 'This MCP Server has passed installation validation, ensuring its quality and reliability', 1, 20, 20),
(2, 1, 'Provides At Least One Installation Method', 'This MCP Server provides 5 installation methods, allowing users to deploy and use it', 1, 15, 15),
(3, 1, 'Includes At Least One Tool', 'This MCP Server provides 8 tool features, allowing users to perform specific operations', 1, 15, 15),
(4, 1, 'Has README', 'This repository contains a README.md file', 1, 10, 10),
(5, 1, 'Offers Friendly Installation Methods', 'This MCP Server offers installation methods friendlier than Manual, allowing users to deploy and use it easily', 1, 10, 10),
(6, 1, 'Includes Resources', 'This MCP Server provides 2 resources, allowing users to attach and manage context data', 1, 5, 5),
(7, 1, 'Has LICENSE', 'This repository contains a LICENSE file', 1, 5, 5),
(8, 1, 'Includes Prompts', 'This MCP Server provides prompts, allowing users to interact with the service', 1, 0, 0),
(9, 1, 'Not Claimed by Owner', 'If you are the owner of this MCP Server, you can claim it via GitHub Badge', 0, 0, 20);

-- MCP Version History Data (connected to Playwright MCP Server)
INSERT INTO mcp_version_history (id, mcp_server_id, version_number, is_validated, published_date) VALUES
(1, 1, '0.0.37', 1, DATE '2025-09-09'),
(2, 1, '0.0.36', 0, DATE '2025-09-01'),
(3, 1, '0.0.35', 0, DATE '2025-08-29'),
(4, 1, '0.0.34', 0, DATE '2025-08-16'),
(5, 1, '0.0.33', 0, DATE '2025-08-09'),
(6, 1, '0.0.32', 0, DATE '2025-07-26'),
(7, 1, '0.0.31', 0, DATE '2025-07-18'),
(8, 1, '0.0.30', 0, DATE '2025-07-15'),
(9, 1, '0.0.29', 0, DATE '2025-06-16');

-- MCP Related Servers Data
INSERT INTO mcp_related_servers (id, mcp_server_id, related_server_id, relationship_type) VALUES
(1, 1, 2, 'complementary'), -- Playwright relates to Obsidian as complementary tools
(2, 2, 1, 'complementary'); -- Obsidian relates to Playwright as complementary tools