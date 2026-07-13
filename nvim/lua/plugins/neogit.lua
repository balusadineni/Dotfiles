-- Magit-style git interface (Neogit) + diffview for diffs and file history.
-- Neogit uses diffview automatically for its diff views.
return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'ibhagwan/fzf-lua', -- picker for branches/commits (already installed)
    },
    cmd = { 'Neogit' },
    keys = {
      { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Neogit (default tab)' },
      { '<leader>gs', '<cmd>Neogit kind=split<cr>', desc = 'Neogit horizontal split' },
      { '<leader>gv', '<cmd>Neogit kind=vsplit<cr>', desc = 'Neogit vertical split' },
      { '<leader>gf', '<cmd>Neogit kind=floating<cr>', desc = 'Neogit floating window' },
      { '<leader>gc', '<cmd>Neogit commit<cr>', desc = 'Neogit commit' },
    },
    config = function()
      require('neogit').setup {
        kind = 'tab', -- default: open status in its own tab
        integrations = {
          diffview = true,
          fzf_lua = true,
        },
      }
    end,
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    keys = {
      -- Review the current branch against the default branch (PR-style, three-dot).
      {
        '<leader>gr',
        function()
          -- Detect the repo's default branch: origin/HEAD -> main -> master.
          local function default_branch()
            local head = vim.fn.systemlist('git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null')[1]
            if head and head ~= '' then return (head:gsub('^origin/', '')) end
            for _, b in ipairs { 'main', 'master' } do
              if vim.fn.system('git rev-parse --verify --quiet ' .. b):match('%S') then return b end
            end
            return 'main'
          end
          vim.cmd('DiffviewOpen ' .. default_branch() .. '...HEAD')
        end,
        desc = 'Git: review branch vs default (PR diff)',
      },
      -- Same range, but as a commit list you can step through SHA by SHA.
      {
        '<leader>gR',
        function()
          local function default_branch()
            local head = vim.fn.systemlist('git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null')[1]
            if head and head ~= '' then return (head:gsub('^origin/', '')) end
            for _, b in ipairs { 'main', 'master' } do
              if vim.fn.system('git rev-parse --verify --quiet ' .. b):match('%S') then return b end
            end
            return 'main'
          end
          vim.cmd('DiffviewFileHistory --range=' .. default_branch() .. '...HEAD')
        end,
        desc = 'Git: review branch commits (SHA list)',
      },
      -- History of the current file: log on the left, pick a SHA, see its diff.
      { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Git: file history (current file)' },
      -- History of the whole repo.
      { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = 'Git: repo history' },
      -- Diff of the working tree against HEAD.
      { '<leader>gD', '<cmd>DiffviewOpen<cr>', desc = 'Git: diff working tree' },
      -- Close any diffview tab.
      { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'Git: close diffview' },
    },
    config = function()
      require('diffview').setup {}
    end,
  },
}
