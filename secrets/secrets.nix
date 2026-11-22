let
  abdurrahmanr = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDXfZvcJj4wPwh8Pkji29Ja9yS6H8SH3o4qhQzIM535C main-agenix";
  nidaime = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwr6I3ydwSZ/85o3+8CD2KqbAF3jkwmwwxB7q6zVb3g root@nidaime";
in
{
  "github-ssh.age".publicKeys = [
    abdurrahmanr
    nidaime
  ];
}
