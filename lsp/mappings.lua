local maps = { i = {}, n = {}, v = {}, t = {}, [""] = {} }

maps.n = {
  ["<leader>bb"] = { "<cmd>tabnew<cr>", desc = "New tab" },
  ["<leader>bc"] = {
    "<cmd>BufferLinePickClose<cr>",
    desc = "Pick to close",
  },
  ["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
  ["<leader>bt"] = {
    "<cmd>BufferLineSortByTabs<cr>",
    desc = "Sort by tabs",
  },

  ["<C-s>"] = { ":w!<cr>", desc = "Save File" },
  ["<C-k>"] = {
    "<cmd>lua vim.lsp.buf.signature_help()<cr>",
    desc = "Signature help",
  },

  ["gf"] = { "<cmd>Lspsaga lsp_finder<CR>", desc = "Lspsaga finder" },
  ["<F2>"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Smart rename" },
  ["<F4>"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code actions" },

  ["<leader>ld"] = {
    "<cmd>Lspsaga peek_definition<CR>",
    desc = "Popup definition",
  },
  ["<leader>lD"] = {
    "<cmd>Telescope lsp_definitions<CR>",
    desc = "Find definitions",
  },
  ["<leader>li"] = {
    "<cmd>Telescope lsp_implementations<CR>",
    desc = "Find implementations",
  },
}

maps.x = {
  ["<F4>"] = {
    "<cmd>lua vim.lsp.buf.range_code_action()<CR>",
    desc = "Range code actions",
  },
}

--
local copy = require("user.utils").copyTable(maps)
for mode, bindings in pairs(copy) do
  for keymap, options in pairs(bindings) do
    bindings[keymap] = options.desc
  end
end

astronvim.which_key_register(copy)

return maps
