return {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        { "<leader>on", "<cmd>ObsidianNew<cr>",       desc = "New note" },
        { "<leader>oo", "<cmd>ObsidianSearch<cr>",    desc = "Search notes" },
        { "<leader>od", "<cmd>ObsidianToday<cr>",     desc = "Daily note" },
        { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
        { "<leader>ol", "<cmd>ObsidianFollowLink<cr>", desc = "Follow link" },
        { "<leader>ot", "<cmd>ObsidianTags<cr>",      desc = "Tags" },
    },
    opts = {
        workspaces = {
            {
                name = "notes",
                path = "~/workspace/notes",
            },
        },
        completion = { nvim_cmp = true },
        ui = { enable = true },
    },
}
