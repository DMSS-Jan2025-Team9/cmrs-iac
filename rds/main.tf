provider "aws" {
    region = "ap-southeast-1"   // your AWS region
}

resource "aws_db_instance" "cmrsRDS" {
    db_name = "cmrsDB"   
    identifier = "cmrs-db"         // name of the database
    instance_class = "db.t4g.micro"     // instance class
    engine = "mysql"                 // specify the SQL database
    engine_version = "8.0.40"         // database version
    username = "cmrs"                   // authentication username
    password = "password123"           // authentication password
    port = 3306                        // port number on which Db instance is running
    allocated_storage = 20
    skip_final_snapshot = true
}