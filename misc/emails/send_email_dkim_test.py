import dkim
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from socket import error as socket_error

smtp_server = "ssl0.ovh.net"
port = 587
sender_email = "no-reply@heroctf.fr"
password = input("Password: ").strip()

receiver_email = "heroctf-test@yopmail.com"
subject = "Test Email"
message_text = "This is a test email sent from Python."
message_html = message_text

dkim_selector = "mail2025"
dkim_private_key_path = "./dkim_heroctf.priv"

sender_domain = sender_email.split("@")[-1]
msg = MIMEMultipart("alternative")
msg.attach(MIMEText(message_text, "plain"))
msg.attach(MIMEText(message_html, "html"))
msg["To"] = receiver_email
msg["From"] = sender_email
msg["Subject"] = subject

msg_data = msg.as_bytes()

if dkim_private_key_path and dkim_selector:
    with open(dkim_private_key_path) as fh:
        dkim_private_key = fh.read()
    headers = [b"To", b"From", b"Subject"]
    sig = dkim.sign(
        message=msg_data,
        selector=str(dkim_selector).encode(),
        domain=sender_domain.encode(),
        privkey=dkim_private_key.encode(),
        include_headers=headers,
    )
    msg["DKIM-Signature"] = sig[len("DKIM-Signature: ") :].decode()
    msg_data = msg.as_bytes()

context = smtplib.ssl.create_default_context()
with smtplib.SMTP(smtp_server, port) as server:
    server.starttls(context=context)
    server.login(sender_email, password)
    server.sendmail(sender_email, receiver_email, msg_data)
