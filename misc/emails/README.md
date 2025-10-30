# Sending emails from CTFd

## SPF

For OVH:

```bash
v=spf1 include:mx.ovh.com ~all
```

## DKIM

```bash
openssl genrsa -out dkim_heroctf.priv 2048
openssl rsa -in dkim_heroctf.priv -pubout -out dkim_heroctf.pub
echo "v=DKIM1; k=rsa; p=$(cat dkim_heroctf.pub | grep -v -- '-----' | tr -d '\n');"
```

Example:

- DKIM selector: `mail2025`
- DNS TXT at `mail2025._domainkey.heroctf.fr`

## Cloud Providers

Many cloud providers block outgoing SMTP connections. For example, Linode states:

> "In an effort to fight spam originating from our platform, outbound connections on ports 25, 465, and 587 are blocked by default on Compute Instances for some new accounts."