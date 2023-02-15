job "iis-test" {
  datacenters = ["dc1"]
  type = "service"

  group "iis-test" {
    count = 1

    network {
      port "httplabel" {}
    }

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    task "iis-test" {
      driver = "win_iis"f

      config {
        path = "C:\\inetpub\\wwwroot"
        bindings {
          type = "http"
          port = "httplabel"
        }
      }

      template {
        data = <<EOH
NOMAD_APPPOOL_USERNAME=Network Service
#NOMAD_APPPOOL_PASSWORD=vagrant
EXAMPLE_ENV_VAR=test123
EOH

        destination = "secrets/file.env"
        env         = true
      }

      resources {
        cpu    = 100
        memory = 20
      }
    }
  }
}