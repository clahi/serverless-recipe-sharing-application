resource "aws_cognito_user_pool" "user_pool" {
  name = "my-pool"

  mfa_configuration = "OFF"
  account_recovery_setting {
    recovery_mechanism {
      name = "verified_email"
      priority = 1
    }
  }

  password_policy {
    minimum_length = 6
    require_lowercase = false
    require_numbers = false
    require_symbols = false
    require_uppercase = false
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
    invite_message_template {
      email_message = "Hello {username} from Recipe Sharring Serverless Application.\nYour temporary password is {####}"
      email_subject = "Serverless recipe sharing app."
    }
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  schema {
    name = "email"
    required = true
    mutable = true
    attribute_data_type = string
  }
}