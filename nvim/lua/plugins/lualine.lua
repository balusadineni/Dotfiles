-- tokyonight-night palette. Flat / no boxy blocks: every section shares the
-- editor background so the bar blends in (like the tmux bar). Color comes from
-- the foreground only; the mode word is tinted per mode (mode-reactive).
local p = {
  bg      = '#1a1b26', -- editor bg; used as bg everywhere -> flat, no blocks
  fg      = '#c0caf5',
  fg2     = '#a9b1d6',
  dim     = '#565f89',
  blue    = '#7aa2f7', -- normal
  green   = '#9ece6a', -- insert
  magenta = '#bb9af7', -- visual
  red     = '#f7768e', -- replace
  yellow  = '#e0af68', -- command
}

-- per-mode: only the mode word (section a/z) changes fg; b/c fall back to normal
local function mode(color)
  return { a = { fg = color, bg = p.bg, gui = 'bold' } }
end

local theme = {
  normal = {
    a = { fg = p.blue, bg = p.bg, gui = 'bold' },
    b = { fg = p.fg2,  bg = p.bg },
    c = { fg = p.dim,  bg = p.bg },
  },
  insert   = mode(p.green),
  visual   = mode(p.magenta),
  replace  = mode(p.red),
  command  = mode(p.yellow),
  inactive = {
    a = { fg = p.dim, bg = p.bg },
    b = { fg = p.dim, bg = p.bg },
    c = { fg = p.dim, bg = p.bg },
  },
}

return {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        icons_enabled = true,
        theme = theme,                 -- flat tokyonight, mode-reactive fg
        component_separators = '',
        section_separators = '',
        globalstatus = true,           -- single bar across all splits (laststatus=3)
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = {
          { 'filename', path = 1 },
          'diagnostics',
        },
        lualine_x = { 'filetype' },
        lualine_y = { 'location' },     -- 34:12
        lualine_z = { 'progress' },     -- 45%
      },
      tabline = {
        lualine_a = { 'buffers' },
      },
    },
  }
