-- Python-specific configuration and tools
return {
  -- Improved Python indentation
  {
    'Vimjas/vim-python-pep8-indent',
    ft = 'python',
  },

  -- Python docstring generation
  {
    'danymat/neogen',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('neogen').setup({
        enabled = true,
        languages = {
          python = {
            template = {
              annotation_convention = 'google_docstrings',
            },
          },
        },
      })
    end,
    keys = {
      {
        '<leader>pd',
        function()
          require('neogen').generate()
        end,
        desc = 'Generate [D]ocstring',
        ft = 'python',
      },
    },
  },

  -- Enhanced Python syntax highlighting and folding
  {
    'tmhedberg/SimpylFold',
    ft = 'python',
    config = function()
      vim.g.SimpylFold_docstring_preview = 1
      vim.g.SimpylFold_fold_docstring = 0
      vim.g.SimpylFold_fold_import = 0
      
      -- Set up Python folding to start with all folds open and add F5 to run script
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'python',
        callback = function()
          vim.opt_local.foldmethod = 'expr'
          vim.opt_local.foldexpr = 'SimpylFold#FoldExpr(v:lnum)'
          vim.opt_local.foldtext = 'SimpylFold#FoldText()'
          vim.opt_local.foldlevel = 99  -- Start with all folds open
          
          -- F5 to save and run Python script (works in both normal and insert mode)
          vim.keymap.set('n', '<F5>', ':w<CR>:!python3 %<CR>', { buffer = true, desc = 'Save and run Python script' })
          vim.keymap.set('i', '<F5>', '<Esc>:w<CR>:!python3 %<CR>', { buffer = true, desc = 'Save and run Python script' })
        end,
        group = vim.api.nvim_create_augroup('PythonFolding', { clear = true }),
      })
    end,
  },

  -- Python virtual environment selector (simplified)
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
    },
    ft = 'python',
    cmd = { 'VenvSelect', 'VenvSelectCached' },
    config = function()
      require('venv-selector').setup({
        settings = {
          options = {
            notify_user_on_venv_activation = true,
          },
        },
      })
    end,
         keys = {
       { '<leader>pv', '<cmd>VenvSelect<cr>', desc = 'Select [V]env' },
       { '<leader>pc', '<cmd>VenvSelectCached<cr>', desc = 'Select [C]ached venv' },
     },
  },
} 