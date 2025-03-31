local function bootstrap_pckr()
  local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

  if not (vim.uv or vim.loop).fs_stat(pckr_path) then
    vim.fn.system({
      'git',
      'clone',
      "--filter=blob:none",
      'https://github.com/lewis6991/pckr.nvim',
      pckr_path
    })
  end

  vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()

require('pckr').add{
		-- Colors
		"rose-pine/neovim";
		-- Niceties
		"ThePrimeagen/harpoon";
		"nvim-telescope/telescope.nvim";
		"Lommix/godot.nvim";

		-- Dependencies
		"nvim-lua/plenary.nvim";
		-- LSP
		"williamboman/mason.nvim";
		"williamboman/mason-lspconfig.nvim";
		"neovim/nvim-lspconfig";

		-- Autocomplete
		"hrsh7th/nvim-cmp";
		"hrsh7th/cmp-buffer";
		'hrsh7th/cmp-path';
		'hrsh7th/cmp-nvim-lsp';
		'hrsh7th/cmp-cmdline';
		"dcampos/nvim-snippy";
}

-- Keybinds
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>re", vim.cmd.Ex)

-- Harpoon
vim.keymap.set("n", "<leader>h", function() require("harpoon.ui").toggle_quick_menu() end)
vim.keymap.set("n", "<leader>a", function() require("harpoon.mark").add_file() end)
vim.keymap.set("n", "<C-h>", function() require("harpoon.ui").nav_file(1) end)
vim.keymap.set("n", "<C-j>", function() require("harpoon.ui").nav_file(2) end)
vim.keymap.set("n", "<C-k>", function() require("harpoon.ui").nav_file(3) end)
vim.keymap.set("n", "<C-l>", function() require("harpoon.ui").nav_file(4) end)

-- Telescope
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader><leader>", telescope.find_files, {})
vim.keymap.set("n", "<leader>gi", telescope.git_files, {})
vim.keymap.set("n", "<leader>fs", function()
        telescope.grep_string({search = vim.fn.input("Grep > ") });
end)

local cmp = require("cmp")
cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require('snippy').expand_snippet(args.body) -- For `snippy` users.
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'snippy' },
	}, {
		{ name = 'buffer' },
	})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	}),
	matching = { disallow_symbol_nonprefix_matching = false }
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require('lspconfig')
local servers = { 'gopls', 'gdscript', 'lua_ls' } --- in my example I'm using gopls and pyright servers

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        capabilities = capabilities
    }
end

--godot.lua
local ok, godot = pcall(require, "godot")
if not ok then
	return
end


-- default config
local config = {
 		bin = "/home/Applications/Godot 4.4 MONO",
}

godot.setup(config)

local function map(m, k, v)
	vim.keymap.set(m, k, v, { silent = true })
end

map("n", "<leader>dr", godot.debugger.debug)
map("n", "<leader>dd", godot.debugger.debug_at_cursor)
map("n", "<leader>dq", godot.debugger.quit)
map("n", "<leader>dc", godot.debugger.continue)
map("n", "<leader>ds", godot.debugger.step)

