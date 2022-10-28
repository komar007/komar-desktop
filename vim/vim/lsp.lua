local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_lsp_attach = function(client)
  -- code navigation shortcuts
  vim.api.nvim_buf_set_keymap(0, 'n', 'gd', ':lua vim.lsp.buf.definition()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', 'gD', ':lua vim.lsp.buf.declaration()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', 'gr', ':Telescope lsp_references<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', 'gi', ':lua vim.lsp.buf.implementation()<CR>', {noremap = true, silent = true})
  -- docs and info
  vim.api.nvim_buf_set_keymap(0, 'n', 'K', ':lua vim.lsp.buf.hover()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', 'td', ':lua vim.lsp.buf.type_definition()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<c-k>', ':lua vim.lsp.buf.signature_help()<CR>', {noremap = true, silent = true})
  -- action shortcuts
  vim.api.nvim_buf_set_keymap(0, 'n', 'ga', ':Telescope lsp_code_actions theme=get_cursor<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>r', ':lua vim.lsp.buf.rename()<CR>', {noremap = true, silent = true})
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

require('rust-tools').setup({
  tools = {
    autoSetHints = true,
  },
})
-- git clone https://github.com/rust-analyzer/rust-analyzer.git
-- cargo xtask install --server
require('lspconfig').rust_analyzer.setup(defcfg)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
})

