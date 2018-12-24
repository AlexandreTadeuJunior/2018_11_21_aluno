require 'httparty'

# created a student
response = HTTParty.post("http://localhost:3000/api/v1/students",
                          :body => {"student[name]": "Joao S", "student[cpf]": "148.917.040-64" , "enem_grade": "530"})
p "Created student"
p "Response code: #{response.code}"
p "Response body: #{response.body}"

# created a billings
study = JSON.parse(response.body)
response = HTTParty.post("http://localhost:3000/api/v1/billings",
                          :body => {"billing[student_id]": study["id"], "billing[desired_due_day]": "20" , "billing[installments_count]": "8"})
p "Created billings"
p "Response code: #{response.code}"
p "Response body: #{response.body}"

# list student
response = HTTParty.get("http://localhost:3000/api/v1/students")
p "List students"
p "Response code: #{response.code}"
p "Response body: #{response.body}"
