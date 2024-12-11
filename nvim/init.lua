vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = false
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.hlsearch = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.api.nvim_set_keymap('n', '<leader>cf', ':let @+=expand("%")<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', '<cmd>bn<cr>', { silent = true, desc = 'Next buffer' })
vim.keymap.set('n', '<C-h>', '<cmd>bp<cr>', { silent = true, desc = 'Previous buffer' })

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
end, { nargs = 1 })

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
  return tabline:sub(1, -2) -- Remove the trailing '|'
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
  local cmd_tcd_first = 'tcd ' .. first_path:gsub(' ', '\\ ') -- Escape spaces in path
  vim.api.nvim_command(cmd_tcd_first)

  -- Set the tab name as the first path name
  local tabname_first = vim.fn.fnamemodify(first_path, ':t')
  vim.api.nvim_tabpage_set_var(0, 'tabname', tabname_first)

  -- Create new tabs for the remaining paths
end

local function tab_add_new_project(paths)
  local path = paths[1]
  vim.api.nvim_command 'tabnew'

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

require('lazy').setup({

  require 'plugins.comment',
  require 'plugins.whichkey',
  require 'plugins.fzf-lua',
  require 'plugins.lualine',
  require 'plugins.neorg',
  require 'plugins.conform',
  require 'plugins.nvim-cmp',
  require 'plugins.tokyonight',
  require 'plugins.nvim-treesitter',
  require 'plugins.neo-tree',
  require 'plugins.fugitive',
  -- require 'plugins.luarocks',
  require 'plugins.rest-nvim',
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
