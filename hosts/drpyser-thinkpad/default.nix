{ suites, ... }:
{
  imports = [
    ./configuration.nix
  ] ++ suites.laptop;

  bud.enable = true;
  bud.localFlakeClone = "/home/drpyser/repositories/devos";
}
