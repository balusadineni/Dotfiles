return {
    'folke/tokyonight.nvim',
    priority = 1000,
    opts = {
        style = 'night',
        styles = {
            -- use the editor background for sidebars (neo-tree, help, qf, …)
            -- instead of tokyonight's darker sidebar bg
            sidebars = 'normal',
            floats = 'normal',
        },
    },
    config = function(_, opts)
        require('tokyonight').setup(opts)
        vim.cmd.colorscheme 'tokyonight-night'
        vim.cmd.hi 'Comment gui=none'
    end,
}
