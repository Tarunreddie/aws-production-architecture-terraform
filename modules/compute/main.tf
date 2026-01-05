data "template_file" "userdata" {
  template = file(var.user_data_path)
}

# IAM role for EC2 (CloudWatch-ready)
resource "aws_iam_role" "ec2_role" {
  name = "${var.project}-${var.env}-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cw_agent" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.project}-${var.env}-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# Target Group
resource "aws_lb_target_group" "tg" {
  name     = "${var.project}-${var.env}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
    matcher             = "200"
  }
}

# ALB
resource "aws_lb" "alb" {
  name               = "${var.project}-${var.env}-alb"
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# Launch Template
resource "aws_launch_template" "lt" {
  name_prefix   = "${var.project}-${var.env}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.this.name
  }

  vpc_security_group_ids = [var.ec2_sg_id]

  user_data = base64encode(data.template_file.userdata.rendered)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project}-${var.env}-app"
    }
  }
}

# Auto Scaling Group (private subnets)
resource "aws_autoscaling_group" "asg" {
  name                = "${var.project}-${var.env}-asg"
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = var.private_subnet_ids

  target_group_arns = [aws_lb_target_group.tg.arn]

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 120
}
