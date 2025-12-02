---@type vim.lsp.Config
return {
  cmd = { "terraform-ls", "serve" },

  filetypes = { "terraform", "terraform-vars" },

  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)

    local root = vim.fs.dirname(vim.fs.find(
      { ".terraform", ".git" },
      { upward = true, path = fname }
    )[1])

    on_dir(root)
  end,
}

