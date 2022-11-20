output "alb_security_group_id" {
 value = aws_security_group.alb_security_group.id
}

# output "ecs_security_group_id" {
#  value = aws_security_group.ecs-security-group.id
# }

output "ssh_security_group_id" {
 value = aws_security_group.ssh-security-group.id
}

output "webserver-security-group_id" {
 value = aws_security_group.webserver-security-group.id
}

output "database-security-group_id" {
 value = aws_security_group.database-security-group.id
}