return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 15,
      open_mapping = [[<C-`>]],
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = "horizontal",
      close_on_exit = true,
      shell = vim.o.shell,
      auto_scroll = true,
    })

    -- Easy escape from terminal mode
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { silent = true })

    -- Navigate between windows from terminal mode
    vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { silent = true })
    vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { silent = true })
    vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { silent = true })
    vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { silent = true })
  end,
}
