{
  description = "BtrieveFileSaver — standalone Btrieve .BTR file reader";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        {
          btrFileSaver = pkgs.stdenv.mkDerivation {
            pname = "btrfilesaver";
            version = "0.1.0";
            src = self;
            enableParallelBuilding = true;
            buildPhase = ''
              runHook preBuild
              make ${if pkgs.stdenv.isDarwin then "bsd" else "linux"}
              runHook postBuild
            '';
            installPhase = ''
              runHook preInstall
              install -Dm755 BtrFileSaver $out/bin/BtrFileSaver
              runHook postInstall
            '';
          };
          default = self.packages.${system}.btrFileSaver;
        });
    };
}
