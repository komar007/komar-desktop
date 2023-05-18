local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_lsp_attach = function(client)
  -- code navigation shortcuts
  vim.api.nvim_buf_set_keymap(0, 'n', 'gd', ':lua telescope_definitions()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', 'gD', ':lua vim.lsp.buf.declaration()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', 'gr', ':lua telescope_references()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', 'gi', ':lua telescope_implementations()<CR>', {noremap = true, silent = true})
  -- docs and info
  vim.api.nvim_buf_set_keymap(0, 'n', 'K', ':lua vim.lsp.buf.hover()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', 'gt', ':lua telescope_type_definitions()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<c-k>', ':lua vim.lsp.buf.signature_help()<CR>', {noremap = true, silent = true})
  -- action shortcuts
  vim.api.nvim_buf_set_keymap(0, 'n', 'ga', ':lua vim.lsp.buf.code_action()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>r', ':lua vim.lsp.buf.rename()<CR>', {noremap = true, silent = true})

  if client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
      vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
      vim.api.nvim_create_autocmd("CursorHold", {
          callback = vim.lsp.buf.document_highlight,
          buffer = bufnr,
          group = "lsp_document_highlight",
          desc = "Document Highlight",
      })
      vim.api.nvim_create_autocmd("CursorMoved", {
          callback = vim.lsp.buf.clear_references,
          buffer = bufnr,
          group = "lsp_document_highlight",
          desc = "Clear All the References",
      })
  end
end

local defcfg = { capabilities = capabilities, on_attach = on_lsp_attach }

-- gentoo's sys-devel/clang should provide clangd
require('lspconfig').clangd.setup(defcfg)
-- pipx install 'python-lsp-server[all]'
require('lspconfig').pylsp.setup(defcfg)
-- npm install -g dockerfile-language-server-nodejs
require('lspconfig').dockerls.setup(defcfg)
-- npm install -g vim-language-server
require('lspconfig').vimls.setup(defcfg)
-- npm i -g vscode-langservers-extracted
require('lspconfig').eslint.setup(defcfg)
-- npm i -g dockerfile-language-server-nodejs
require('lspconfig').dockerls.setup(defcfg)

require('rust-tools').setup({
  server = defcfg, -- configuration for rust-analyzer (it cannot be setup separately)
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
})
