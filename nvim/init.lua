vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
-- vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10
vim.opt.hlsearch = true


-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- My keymap suggestions
vim.keymap.set('n', '<C-l>', '<cmd>bn<cr>', { silent = true, desc = 'Next buffer' })
vim.keymap.set('n', '<C-h>', '<cmd>bp<cr>', { silent = true, desc = 'Previous buffer' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_user_command('TabRename', function(input)
  local tabname = input.args
  vim.api.nvim_tabpage_set_var(0, 'tabname', tabname)
end, { nargs = 1})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)


local function get_tab_name(n)
  local ok, tabname = pcall(vim.api.nvim_tabpage_get_var, n, 'tabname')
  return ok and tabname or ('Tab ' .. tostring(n))
end

-- Function to create tabline
local function tab_name()
  local tabs = vim.api.nvim_list_tabpages()
  local current_tab = vim.api.nvim_get_current_tabpage()
  local tabline = ''
  for _, tabnr in ipairs(tabs) do
    local tabname = get_tab_name(tabnr)
    if tabnr == current_tab then
      tabline = tabline .. '%#TabLineSel# ' .. tabname .. ' %#TabLine#|'
    else
      tabline = tabline .. ' ' .. tabname .. ' |'
    end
  end
  return tabline:sub(1, -2)  -- Remove the trailing '|'
end

-- Function to split a string by a given delimiter
-- local function split_string(inputstr, sep)
--   if sep == nil then
--     sep = "%s"  -- Default delimiter is space if not provided
--   end
--   local t = {}
--   for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
--     table.insert(t, str)
--   end
--   return t
-- end


local function tab_new_project(paths)
  local first_path = paths[1]
  local cmd_tcd_first = 'tcd ' .. first_path:gsub(' ', '\\ ')  -- Escape spaces in path
  vim.api.nvim_command(cmd_tcd_first)
 
  -- Set the tab name as the first path name
  local tabname_first = vim.fn.fnamemodify(first_path, ':t')
  vim.api.nvim_tabpage_set_var(0, 'tabname', tabname_first)

  -- Create new tabs for the remaining paths
end

local function tab_add_new_project(paths)
  local path = paths[1]
  vim.api.nvim_command('tabnew')
  
  local cmd_tcd = 'tcd' .. path:gsub(' ', '\\ ')
  vim.api.nvim_command(cmd_tcd)
  local tabname = vim.fn.fnamemodify(path, ':t')
  vim.api.nvim_tabpage_set_var(0, 'tabname', tabname)
end

vim.api.nvim_create_user_command('AddNewProject', function(input)
  local paths = { input.args }
  tab_new_project(paths)
end, { nargs = 1 })

vim.api.nvim_create_user_command('Addproject', function(input)
  local paths = { input.args }
  tab_add_new_project(paths)
end, { nargs = 1 })


-- vim.api.nvim_create_user_command('Workspace', function()
--   local paths = {
--     '~/workspace/apps',
--     '~/workspace/rosetta',
--     '~/workspace/milky-way',
--     '~/workspace/gems',
--     '~/workspace/myscripbox-api',
--     '~/workspace/k8s-apps'
--   }
--
--   create_tabs_with_paths(paths)
--
-- end, { nargs = 0})
--

require('lazy').setup({


  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',    opts = {} },

   {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization

      require("fzf-lua").setup({
        "fzf-native",
        winopts = {
          split = "belowright 15new",  
          border = "single",
          preview = {
            hidden = "hidden",
            border = "border",
            title = true,
            layout = "flex",
            horizontal = "right:40%",
          }
        },
        on_create = function()
          vim.keymap.set("t", "<C-k>", "Up", {silent = true, buffer = true })
        end,
      })

      vim.keymap.set("n", "<c-P>", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
      vim.keymap.set("n", "<c-O>", "<cmd>lua require('fzf-lua').buffers()<CR>", { silent = true })
      vim.keymap.set("n", "<c-G>", "<cmd>lua require('fzf-lua').git_files()<CR>", { silent = true })
      vim.keymap.set("n", "<c-F>", "<cmd>lua require('fzf-lua').live_grep()<CR>", { silent = true })
      vim.keymap.set("n", "<A-P>", "<cmd>lua require('fzf-lua').colorschemes({ winopts = {}})<CR>", { silent = true })
    end
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_seperators = '|',
        section_seperators = '',
      },
      sections = {
        lualine_c = { { 'filename', path = 1 } }
      },
      tabline = {
        lualine_a = { 'buffers' },
        lualine_z = { tab_name },
      },
    },
  },
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
    opts = {
      rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" }
    }
  },
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    dependencies = { "luarocks.nvim" },
    config = function()
      require("rest-nvim").setup()
    end,
  },

  {
    -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        elixir = { 'mix' }
      },
    },
  },

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',
      'neovim/nvim-lspconfig',
    },
    config = function()
      -- Setup nvim-cmp
      local cmp = require'cmp'
      local luasnip = require'luasnip'

      -- Load friendly-snippets
      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' }, -- For luasnip users.
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
        })
      })

      -- Setup lspconfig.
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      require('lspconfig')['pyright'].setup {
        capabilities = capabilities
      }
    end
  },

  {
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      vim.cmd.colorscheme 'tokyonight-night'

      vim.cmd.hi 'Comment gui=none'
    end,
  },

  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
    {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc', 'elixir', 'eex',
        'python', 'typescript' },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)

      require('nvim-treesitter.install').prefer_git = true
      require('nvim-treesitter.configs').setup(opts)

    end,
  },

  require 'plugins.neo-tree',
  require 'plugins.gitsigns', -- adds gitsigns recommend keymaps
  --[[ { import = 'custom.plugins' }, ]]
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
