{
  config,
  pkgs,
  inputs,
  ...
}:

{

  imports = [
    inputs.nvf.homeManagerModules.default
  ];

  programs.nvf = {
    enable = true;

    settings = {

      vim = {
        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };
        lsp.enable = true;
        treesitter.enable = true;

        # Optional but nice
        statusline.lualine.enable = true;

        # cmp.enable = true; # Completion engine -> apparently wrong line
        telescope.enable = true; # Fuzzy finder
      };
    };
  };
}
