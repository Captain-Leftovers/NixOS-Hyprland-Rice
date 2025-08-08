{
  config,
  pkgs,
  inputs,
  ...
}:

{
 
 #  package = inputs.neovim-overlay.packages.${pkgs.system}.neovim;
        
   programs.neovim = {
    enable = true;

    # ✅ Use nightly Neovim from your overlay
  #  package = pkgs.neovim;

    # Optional: set alias so `vim` launches `nvim`
    viAlias = true;
    vimAlias = true;
  };

}
