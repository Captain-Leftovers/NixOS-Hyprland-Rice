{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [ inputs.nvf.homeManagerModules.default ];

        

  programs.nvf = {
    enable = true;

    settings = {
     vim = {
 
      package =
        inputs.neovim-overlay.packages.${pkgs.system}.neovim;

      theme = {
        enable = true;
        name = "gruvbox";
        style = "dark";
      };

        lsp = {
  enable = true;
        
  servers = {
    nixd = {
        
      enable = true;
         lspconfig = {
                filetypes = [ "nix" ];
              };
    };

    # Do not include nil_ls at all
     # ❌ REMOVE or DISABLE: nil_ls
            nil_ls = {
              enable = false;
            };
  };
};

      treesitter = {
      enable = true;

      };

      statusline.lualine.enable = true;
      telescope = {
      enable = true;
        
        };
      #Languages support
      languages = {
      #  nix.enable = true; #not usre if this overrides nixd wth nil_ls if enabled
        ts.enable = true;
        };


      # Updated namespaces
      autocomplete."nvim-cmp".enable = true;
      autopairs."nvim-autopairs".enable = true;
      mini."ai".enable = true; # for in-editor LLM UI
      };
    };
  };
}
