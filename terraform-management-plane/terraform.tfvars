project_id = "my-gcp-project"
analytics_region = "asia-south1"

envgroups = {
  test = ["test.example.com"]
  prod = ["prod.example.com"]
}

environments = {
  apis-test = {
    display_name = "APIs test"
    description  = "APIs Test"
    envgroups    = ["test"]
  }
  apis-prod = {
    display_name = "APIs prod"
    description  = "APIs prod"
    envgroups    = ["prod"]
  }
}
