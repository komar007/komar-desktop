require("telescope").setup {
  defaults = {
    path_display={"truncate"},
    mappings = {
      n = {
        ['<c-d>'] = require('telescope.actions').delete_buffer
      },
      i = {
        ['<c-d>'] = require('telescope.actions').delete_buffer
      },
    },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_ivy {}
    }
  }
}
require("telescope").load_extension("ui-select")

local main_theme = require('telescope.themes').get_ivy({
  layout_config = {
    height = 10000,
  },
})

telescope_findfiles = function(config)
  require('telescope.builtin').find_files(main_theme)
end
telescope_buffers = function(config)
  require('telescope.builtin').buffers(main_theme)
end
