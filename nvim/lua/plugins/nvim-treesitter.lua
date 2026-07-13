return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main', -- master is frozen and incompatible with Neovim 0.11+/0.12
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup()

    -- Parsers to keep installed. NOTE: norg/norg_meta are NOT in the
    -- nvim-treesitter registry; Neorg installs those itself.
    local ensure_installed = {
      'bash',
      'c',
      'diff',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'vim',
      'vimdoc',
      'elixir',
      'eex',
      'heex',
      'python',
      'typescript',
      'tsx',
      'http',
      'json',
      'kotlin',
      'yaml',
      'toml',
    }
    require('nvim-treesitter').install(ensure_installed)

    -- The main branch does not wire up highlight/indent/fold automatically.
    -- Enable them per-buffer whenever a parser exists for the filetype.
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('user_treesitter', { clear = true }),
      callback = function(ev)
        if not pcall(vim.treesitter.start) then
          return
        end
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo.foldmethod = 'expr'
      end,
    })
  end,
}
