import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart


smtp_server = "ssl0.ovh.net"
port = 587
sender_email = "no-reply@heroctf.fr"
password = input("Password: ").strip()

receiver_email = "heroctf-test@yopmail.com"
subject = "Test Email"
body = "This is a test email sent from Python."

message = MIMEMultipart()
message["From"] = sender_email
message["To"] = receiver_email
message["Subject"] = subject

message.attach(MIMEText(body, "plain"))

context = smtplib.ssl.create_default_context()
with smtplib.SMTP(smtp_server, port) as server:
    server.starttls(context=context)
    server.login(sender_email, password)
    server.sendmail(sender_email, receiver_email, message.as_string())
