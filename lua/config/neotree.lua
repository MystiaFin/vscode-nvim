local M = {}

M.setup = function()
  require("neo-tree").setup({
    close_if_last_window = true,
    filesystem = {
      window = {
        mappings = {
          ["<C-n>"] = "add",
          ["<C-d>"] = "delete",
          ["<C-b>"] = "close_window",
          ["<C-r>"] = "rename",
          ["<C-x>"] = "cut_to_clipboard",
          ["h"] = function(state)
            local node = state.tree:get_node()
            local commands = require("neo-tree.sources.filesystem.commands")
            if node.type == "directory" and node:is_expanded() then
              commands.close_node(state)
            else
              local parent_id = node:get_parent_id()
              if parent_id then
                commands.close_node(state, parent_id)
              end
            end
          end,
        },
      },
    },
  })

  -- toggle focus with "-"
  vim.keymap.set("n", "-", function()
    if vim.bo.filetype == "neo-tree" then
      vim.cmd("wincmd p")
    else
      vim.cmd("Neotree focus")
    end
  end, { silent = true })

  -- Toggle Neo-tree with <C-b>
  vim.keymap.set("n", "<C-b>", function()
    local is_neotree = vim.bo.filetype == "neo-tree"
    require("neo-tree.command").execute({
      toggle = true,
      source = "filesystem",
      position = "left",
      reveal = true,
    })
    -- Return focus to previous window if we just opened neo-tree
    if not is_neotree then
      vim.cmd("wincmd p")
    end
  end, { silent = true, desc = "Neo-tree: toggle sidebar" })

  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      vim.cmd("Neotree show left")
    end,
  })
end

return M
