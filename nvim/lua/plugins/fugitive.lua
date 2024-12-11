return {
  {
    'tpope/vim-fugitive',
    config = function()
      vim.api.nvim_set_keymap('n', 'gs', ':vertical Git<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', 'gb', ':vertical Git blame<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', 'gl', ':vertical Git log<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', 'gd', ':vertical Git diff<cr>', { noremap = true, silent = true })
    end,
  },
}

