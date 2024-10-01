import sys
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart


if len(sys.argv) != 2:
    print("Usage: python3 send_email_test.py <password>")
    exit()

smtp_server = "ssl0.ovh.net"
port = 587
sender_email = "no-reply@heroctf.fr"
password = sys.argv[1]

context = smtplib.ssl.create_default_context()
receiver_email = "heroctf-test@yopmail.com"
subject = "Test Email"
body = "This is a test email sent from Python."

message = MIMEMultipart()
message["From"] = sender_email
message["To"] = receiver_email
message["Subject"] = subject

message.attach(MIMEText(body, "plain"))

with smtplib.SMTP(smtp_server, port) as server:
    server.starttls(context=context)
    server.login(sender_email, password)
    server.sendmail(sender_email, receiver_email, message.as_string())
