return {
  'nvim-neorg/neorg',
  lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  version = '9.3.0', -- Pin Neorg to the latest stable release
  config = true,

  -- [[SET NEORG]]
  require('neorg').setup {
    load = {
      ['core.defaults'] = {},
      ['core.concealer'] = {},
      ['core.dirman'] = {},
      ['core.export'] = {},
      ['core.summary'] = {},
    },
  },
}
