{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "apache2-example";
  src = ./.;

  buildInputs = [
    pkgs.apacheHttpd
  ];

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${pkgs.apacheHttpd}/bin/httpd $out/bin/httpd
  '';
}
