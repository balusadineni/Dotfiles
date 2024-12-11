return {
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
          backdrop = 60,
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

      vim.keymap.set("n", "<c-F>", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
      vim.keymap.set("n", "<c-B>", "<cmd>lua require('fzf-lua').buffers()<CR>", { silent = true })
      --vim.keymap.set("n", "<c-G>", "<cmd>lua require('fzf-lua').git_files()<CR>", { silent = true })
      vim.keymap.set("n", "<c-g>", "<cmd>lua require('fzf-lua').live_grep()<CR>", { silent = true })
      vim.keymap.set("n", "<c-G>", "<cmd>lua require('fzf-lua').live_grep_resume()<CR>", { silent = true })

      vim.keymap.set("n", "<A-P>", "<cmd>lua require('fzf-lua').colorschemes({ winopts = {}})<CR>", { silent = true })
    end
  }
