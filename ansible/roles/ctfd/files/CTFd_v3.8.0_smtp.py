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

            msg = EmailMessage()
            msg.set_content(text)

            msg["Subject"] = subject
            msg["From"] = mailfrom_addr
            msg["To"] = addr

            # ==== PATCH START ==== #
            import dkim
            from os import getenv

            dkim_private_key_path = getenv("DKIM_PRIVATE_KEY_PATH")
            dkim_selector = getenv("DKIM_SELECTOR")

            with open(dkim_private_key_path, "rb") as dkim_private_file:
                dkim_private_key = dkim_private_file.read()

            headers = [b"To", b"From", b"Subject"]
            sig = dkim.sign(
                message=msg.as_bytes(),
                selector=str(dkim_selector).encode(),
                domain=sender_domain.encode(),
                privkey=dkim_private_key,
                include_headers=headers,
            )
            msg["DKIM-Signature"] = sig[len("DKIM-Signature: ") :].decode()
            msg = msg.as_bytes()
            # ==== PATCH END ==== #

            # Check whether we are using an admin-defined SMTP server
            custom_smtp = bool(get_config("mail_server"))

            # We should only consider the MAILSENDER_ADDR value on servers defined in config
            if custom_smtp:
                smtp.send_message(msg)
            else:
                mailsender_addr = get_app_config("MAILSENDER_ADDR")
                smtp.send_message(msg, from_addr=mailsender_addr)

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
