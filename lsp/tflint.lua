---@type vim.lsp.Config
return {
  cmd = { "tflint", "--langserver" },

  filetypes = { "terraform" },

  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)

    local root = vim.fs.dirname(vim.fs.find(
      { ".terraform", ".git", ".tflint.hcl" },
      { upward = true, path = fname }
    )[1])

    on_dir(root)
  end,
}

