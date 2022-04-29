let
  # set ssh public keys here for your system and user
  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBuJ8edzcw9KW+xWlt/2OCpYHMfhVcoo0l46B1kiGfRC root@drpyser-thinkpad";
  user = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDnr7PKRb/MKrXL4PC77BdgsHwYa33On+v+U/QA/Gz4J9xQscUnv3gV53e9Wuc77ovxJoG4kqLIUXpjWTeRLtfecoMvu+zXnZ45bv3pMGzqRUK0s8mrNqsHbgxOY11QR0TejoeHuO0+8l97n7LSstTrfmMaK77ro1Mm4ir4OysuhRK3QpL8Rst+nuRJIg4NsIda4Ja4rIM8buBTftNtY4O86exO4F57at69q7pNAPi5WADta2OCzkPTBZpbka+FsfVza3LQO7m/PTr1Uwyf1ss97c6ScgjoEJz1NrniZczy6xOp2OhDnwIOJlzeDeIbLhgxwPFe4ylNT9oMwk5v+a5J drpyser@drpyser-thinkpad";
  allKeys = [ system user ];
in
{
  "drpyser-password.age".publicKeys = allKeys;
}
