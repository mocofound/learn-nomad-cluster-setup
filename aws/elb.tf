# resource "aws_elb" "server_lb" {
#   name               = "${var.prefix}-server-lb"
#   availability_zones = distinct(aws_instance.server.*.availability_zone)
#   internal           = false
#   instances          = aws_instance.server.*.id
#   listener {
#     instance_port     = 4646
#     instance_protocol = "http"
#     lb_port           = 4646
#     lb_protocol       = "http"
#   }
#   listener {
#     instance_port     = 8500
#     instance_protocol = "http"
#     lb_port           = 8500
#     lb_protocol       = "http"
#   }
#   security_groups = [aws_security_group.consul_nomad_ui_ingress.id]
# }

resource "aws_elb" "client_lb" {
  name               = "${var.prefix}-client-lb"
  availability_zones = distinct(aws_instance.client.*.availability_zone)
  internal           = false
  instances          = aws_instance.client.*.id
  

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 8080
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 9999
    instance_protocol = "http"
    lb_port           = 9999
    lb_protocol       = "http"
  }
  listener {
    instance_port     = 9998
    instance_protocol = "http"
    lb_port           = 9998
    lb_protocol       = "http"
  }
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  security_groups = [aws_security_group.clients_ingress.id]
}

# resource "aws_elb" "client_lb" {
#   name               = "${var.prefix}-client-lb-80"
#   availability_zones = distinct(aws_instance.client.*.availability_zone)
#   internal           = false
#   instances          = aws_instance.client.*.id
#   listener {
#     instance_port     = 80
#     instance_protocol = "http"
#     lb_port           = 80
#     lb_protocol       = "http"
#   }
#   security_groups = [aws_security_group.clients_ingress.id]
# }
