resource "aws_key_pair" "kube-ssh-keypair-01" {
  key_name    = "ssh-key"
  public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDc9j1kL96ggpwdqzsEel0H0eEConXcJHUJObJ8aRmqrl5OSZ0qEuXPcByzNBt3/1Zb11yjyllB7JH3qbOVTLajbnUorhRwzmcqTR/L0l/y8qf/NYfWhMZQqEUZXMm4fvjo6xnpc/7zZk0LE7Ue00tz2Jw2o7QfsROjUPrsRG9pp0/xKFB1KJsknI4n2uqlUcdl8QAUcchVbnXleB0OTX3QOzfwPNjuIWMTblG1FGAgbJrro+qCz+YzyuSSkqBNiIw9W9CxwgMBYWRcuf2jAzaEeDtMdUWX5oRYfSyEmahC82X1dFSD+ktZ+EP0i2y2hwKnCkc1O1NmBnM+jYGIayO5Hs9GxyIbXFx/k9WSMNMI/6bF31LBcI4WBysZP6jQFtigxUTzCKw9vQmw6Qq210vaS//Gjeq+9xFfxKWQ/3nEM5zCTWGozA6doJ85VzctnIjrierUHtjWBXBx8BgOxZYIQWWB3Qqv76eNbV39x3ciwMoOxhrJ/UTkix1DJBEYK1E= bogdan@DESKTOP-29ET554"

  tags = {
    Name  = "kube-ssh-keypair-01"
  }
}
