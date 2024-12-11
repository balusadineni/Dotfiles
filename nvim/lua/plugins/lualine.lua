return {
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
  }
