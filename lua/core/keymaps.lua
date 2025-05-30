vim.keymap.set({ "n", "v" }, "<leader>f", function()
	if vim.bo.filetype == "log" then
		vim.cmd([[%s/^\([^|]*|[^|]*|[^|]*|[^|]*|\)\s*\(.*\)$/\1\r\2\r/]])
		vim.cmd("noh")
	else
		require("conform").format({ async = true, lsp_fallback = true })
	end
end, { desc = "Format file or selection" })

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

vim.keymap.set("n", "<leader>fb", function()
	require("telescope").extensions.file_browser.file_browser()
end, { desc = "File browser" })
vim.keymap.set("n", "<leader>/", function()
	require("telescope.builtin").current_buffer_fuzzy_find()
end, { desc = "Find in current file" })
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })

vim.keymap.set("n", "<leader>fg", function()
	local is_git = vim.fn.isdirectory(".git") == 1
	local opts = {}

	if is_git then
		opts.search_dirs = vim.fn.systemlist("git ls-files")
	end

	require("telescope.builtin").live_grep(opts)
end, { desc = "Live grep (Git files if in repo)" })

-- Smart fallback if not in Git repo
vim.keymap.set("n", "<leader>p", function()
	local ok = pcall(require("telescope.builtin").git_files)
	if not ok then
		require("telescope.builtin").find_files()
	end
end, { desc = "Project files (smart)" })

-- All project files
vim.keymap.set("n", "<leader>ff", function()
	require("telescope.builtin").find_files({
		hidden = true,
		no_ignore = true,
		find_command = {
			"rg",
			"--files",
			"--hidden",
			"--no-ignore",
			"--glob",
			"!**/node_modules/**",
			"--glob",
			"!**/__pycache__/**",
			"--glob",
			"!**/.venv/**",
			"--glob",
			"!**/.git/**",
		},
	})
end, { desc = "Find Files (all besides .venv, .git ,.node_modules)" })

-- plugins/outline.lua
vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline" })

vim.keymap.set("n", "<leader>r", function()
  -- this builds “:IncRename <oldName>” for you
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true, desc = "LSP: Incremental rename" })

