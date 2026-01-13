# Reference TFLint will use
plugin "aws" {
  enabled = true

  # Version of AWS rules used by TFLint
  version = "0.27.0"
  
  # Tells TFLint where to download the plugin from
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}