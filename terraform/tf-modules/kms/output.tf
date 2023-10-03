output "policy" {
  value = aws_kms_key.rnd-kms-key.policy
}

output "key_id" {
  value = aws_kms_key.rnd-kms-key.key_id
}

output "arn" {
  value = aws_kms_key.rnd-kms-key.arn
}

output "key_alias_arn" {
  description = "The Amazon Resource Name (ARN) of the key alias"
  value       = aws_kms_alias.rnd-key-alias.arn
}

output "key_alias_name" {
  description = "The display name of the alias."
  value       = aws_kms_alias.rnd-key-alias.name
}
