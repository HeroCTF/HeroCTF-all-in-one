# CTFd version 3.8.0 - https://github.com/CTFd/CTFd/blob/3.8.0/CTFd/utils/email/providers/smtp.py
import smtplib
from email.message import EmailMessage
from email.utils import formataddr
from socket import timeout

from CTFd.utils import get_app_config, get_config
from CTFd.utils.email.providers import EmailProvider


class SMTPEmailProvider(EmailProvider):
    @staticmethod
    def sendmail(addr, text, subject):
        ctf_name = get_config("ctf_name")
        mailfrom_addr = get_config("mailfrom_addr") or get_app_config("MAILFROM_ADDR")
        mailfrom_addr = formataddr((ctf_name, mailfrom_addr))

        data = {
            "host": get_config("mail_server") or get_app_config("MAIL_SERVER"),
            "port": int(get_config("mail_port") or get_app_config("MAIL_PORT")),
        }
        username = get_config("mail_username") or get_app_config("MAIL_USERNAME")
        password = get_config("mail_password") or get_app_config("MAIL_PASSWORD")
        TLS = get_config("mail_tls") or get_app_config("MAIL_TLS")
        SSL = get_config("mail_ssl") or get_app_config("MAIL_SSL")
        auth = get_config("mail_useauth") or get_app_config("MAIL_USEAUTH")

        if username:
            data["username"] = username
        if password:
            data["password"] = password
        if TLS:
            data["TLS"] = TLS
        if SSL:
            data["SSL"] = SSL
        if auth:
            data["auth"] = auth

        try:
            smtp = get_smtp(**data)

            # ==== PATCH START ==== #
            from os import getenv
            from email.mime.multipart import MIMEMultipart
            from email.mime.text import MIMEText

            import dkim

            msg = MIMEMultipart("alternative")
            msg.attach(MIMEText(text, "plain"))

            msg["To"] = addr
            msg["From"] = mailfrom_addr
            msg["Subject"] = subject

            dkim_private_key_path = getenv("DKIM_PRIVATE_KEY_PATH")
            dkim_selector = getenv("DKIM_SELECTOR")

            with open(dkim_private_key_path, "rb") as dkim_private_file:
                dkim_private_key = dkim_private_file.read()

            headers = [b"To", b"From", b"Subject"]
            sig = dkim.sign(
                message=msg.as_bytes(),
                selector=str(dkim_selector).encode(),
                domain=mailfrom_addr.split("@")[-1].strip("<> ").encode(),
                privkey=dkim_private_key,
                include_headers=headers,
            )
            msg["DKIM-Signature"] = sig[len("DKIM-Signature: ") :].decode()
            msg_data = msg.as_bytes()

            smtp.sendmail(mailfrom_addr, addr, msg_data)
            # ==== PATCH END ==== #

            smtp.quit()
            return True, "Email sent"
        except smtplib.SMTPException as e:
            return False, str(e)
        except timeout:
            return False, "SMTP server connection timed out"
        except Exception as e:
            return False, str(e)


def get_smtp(host, port, username=None, password=None, TLS=None, SSL=None, auth=None):
    if SSL is None:
        smtp = smtplib.SMTP(host, port, timeout=3)
    else:
        smtp = smtplib.SMTP_SSL(host, port, timeout=3)

    if TLS:
        smtp.starttls()

    if auth:
        smtp.login(username, password)
    return smtp
