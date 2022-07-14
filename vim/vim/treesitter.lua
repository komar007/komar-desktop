require'nvim-treesitter.configs'.setup {
  ensure_installed = {"c", "java", "rust", "vim", "lua", "python", "html", "css", "javascript", "dockerfile"},
  sync_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  rainbow = {
    enable = true,
  }
}
