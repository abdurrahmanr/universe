{ stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "monochrome-gtk";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "pwyde";
    repo = "monochrome-kde";
    rev = "1c9983e8d1384ec2d9ff0fac59c5265fc74d0e6b";
    hash = "sha256-mnEQQ2PHzARv65PSwGDyS2bcYlRUydD5HUmVD251Tts=";
  };

  dontBuild = true;

  meta.priority = -10;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -r gtk/Monochrome $out/share/themes/Breeze-Dark
    runHook postInstall
  '';
}
