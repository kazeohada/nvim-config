-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
      'nvim-telescope/telescope.nvim', tag = '0.1.8',
      -- or                            , branch = '0.1.x',
      requires = { {'nvim-lua/plenary.nvim'}, {'BurntSushi/ripgrep'}}
    }

    use {
      'nvim-treesitter/nvim-treesitter', 
      branch = 'master', 
      run = ':TSUpdate'
    }
    use ('nvim-treesitter/playground')
    use ('theprimeagen/harpoon')
    use ('mbbill/undotree')
    use ('tpope/vim-fugitive')
    use ('sindrets/diffview.nvim')
    use ('airblade/vim-gitgutter')

    use ('hrsh7th/nvim-cmp')
    use ('hrsh7th/cmp-nvim-lsp')
    use ('hrsh7th/cmp-vsnip')
    use ('hrsh7th/vim-vsnip')

    use({
        "L3MON4D3/LuaSnip",
        tag = "v2.*", 
        run = "make install_jsregexp"
    })
    use ('rafamadriz/friendly-snippets')

    use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
    })

    use ('hashivim/vim-terraform')

    use ('rebelot/kanagawa.nvim')

    use { 'martineausimon/nvim-lilypond-suite' }
end)
