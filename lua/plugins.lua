local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd(
  "BufWritePost",
  { command = "source <afile> | PackerCompile", group = packer_group, pattern = "plugins.lua" }
)

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end
vim.api.nvim_command("packadd packer.nvim")
-- returns the require for use in `config` parameter of packer's use
-- expects the name of the config file
function get_setup(name)
  return string.format('require("setup/%s")', name)
end

return require("packer").startup({
  function(use)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")
    use({ "EdenEast/nightfox.nvim", config = get_setup("nightfox") })
    -- use({ "mcchrish/zenbones.nvim", requires = "rktjmp/lush.nvim", config = get_setup("zenbones") })
    use({ "kyazdani42/nvim-web-devicons" })
    use({
      "nvim-lualine/lualine.nvim",
      config = get_setup("lualine"),
      event = "VimEnter",
      requires = { "kyazdani42/nvim-web-devicons", opt = true },
    })
    use({
      "folke/zen-mode.nvim",
      config = get_setup("zen-mode"),
    })
    use({
      "norcalli/nvim-colorizer.lua",
      event = "BufReadPre",
      config = get_setup("colorizer"),
    })
    -- Post-install/update hook with neovim command
    use({
      "nvim-treesitter/nvim-treesitter",
      config = get_setup("treesitter"),
      run = ":TSUpdate",
    })
    use("nvim-treesitter/nvim-treesitter-textobjects")
    use({
      "windwp/nvim-autopairs",
      after = "nvim-cmp",
      config = get_setup("autopairs"),
    })
    use({
      "hrsh7th/nvim-cmp",
      requires = {
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lua" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-cmdline" },
        { "hrsh7th/vim-vsnip" },
        { "hrsh7th/cmp-vsnip" },
        { "hrsh7th/vim-vsnip-integ" },
        { "f3fora/cmp-spell", { "hrsh7th/cmp-calc" }, { "hrsh7th/cmp-emoji" } },
        { "rafamadriz/friendly-snippets" },
      },
      config = get_setup("cmp"),
    })
    -- use({
    --   "rlane/pounce.nvim",
    --   config = get_setup("pounce"),
    -- })
    use({
      "lewis6991/gitsigns.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      event = "BufReadPre",
      config = get_setup("gitsigns"),
    })

    use("p00f/nvim-ts-rainbow")

    use({ "jose-elias-alvarez/null-ls.nvim", config = get_setup("null-ls") })
    use({ "neovim/nvim-lspconfig", config = get_setup("lsp") })
    use({
      "numToStr/Comment.nvim",
      config = get_setup("comment"),
    })
    use({
      "nvim-telescope/telescope.nvim",
      module = "telescope",
      cmd = "Telescope",
      requires = {
        { "nvim-lua/popup.nvim" },
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      },
      config = get_setup("telescope"),
    })
    use({ "nvim-telescope/telescope-file-browser.nvim" })
    use({ "onsails/lspkind-nvim", requires = { { "famiu/bufdelete.nvim" } } })
    use({ "tpope/vim-repeat" })
    use({ "tpope/vim-surround" })
    use({ "wellle/targets.vim" })
    -- use({ "Shatur/neovim-session-manager", config = get_setup("session") })
    -- use({
    --  "rmagatti/session-lens",
    --  requires = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
    --  config = get_setup("session"),
    -- })
    use({ "windwp/nvim-ts-autotag" })

    use({
      "winston0410/range-highlight.nvim",
      requires = { { "winston0410/cmd-parser.nvim" } },
      config = get_setup("range-highlight"),
    })
    use({ "stevearc/dressing.nvim" })
    use({ "goolord/alpha-nvim", config = get_setup("alpha") })

    use({ "luukvbaal/stabilize.nvim", config = get_setup("stabilize") })
    use({
      "simrat39/symbols-outline.nvim",
      cmd = { "SymbolsOutline" },
      setup = get_setup("outline"),
    })
    if packer_bootstrap then
      require("packer").sync()
    end
  end,
  config = {
    display = {
      open_fn = require("packer.util").float,
    },
    profile = {
      enable = true,
      threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
    },
  },
})
