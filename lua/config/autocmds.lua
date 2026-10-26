-- If closing the current window with :q would leave only "sidebar" /
-- utility windows behind (nvim-tree, undotree, fugitive status/blame,
-- claude code terminal, quickfix, help, etc.) with no real code buffer
-- left to edit, quit Neovim entirely instead of stranding those windows.
--
-- A window counts as a "real" code pane when its buffer has an empty
-- buftype (a normal file or scratch buffer). Everything else (nofile,
-- nowrite, acwrite, terminal, quickfix, help, prompt, ...) is treated
-- as a sidebar/utility window.
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local curwin = vim.api.nvim_get_current_win()
    local real_wins = 0
    local other_wins = 0

    for _, w in ipairs(vim.api.nvim_list_wins()) do
      if w ~= curwin and vim.api.nvim_win_get_config(w).relative == "" then
        local buf = vim.api.nvim_win_get_buf(w)
        if vim.bo[buf].buftype == "" then
          real_wins = real_wins + 1
        else
          other_wins = other_wins + 1
        end
      end
    end

    if real_wins == 0 and other_wins > 0 then
      -- Defer until after the current :quit finishes closing its window,
      -- rather than nesting a :qa inside the in-progress :q.
      vim.schedule(function()
        vim.cmd("qa")
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "yaml", "jsonnet" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})
