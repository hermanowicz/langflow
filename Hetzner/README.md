# langflow deploy

Preping and testing production deployment of open source ersion of langflow

```sh
uv run langflow run --env-file .env
```

### Current state

Soo it looks like recomended way to deploy langflow is to:
use docker compose on servers, there is strong dependence on storage for files created by langflow.
this is very similar to Wordpress content hosting. You can have multiple instances,
but external data strore line NAS (Network Atached Storage) will be required to sync data.

Postgres is not a big problem there is normal connection over network used.

### Generating cert

```bash
openssl req -newkey rsa:2048 -nodes -keyout private_key.pem -x509 -days 365 -out public_certificate.pem
```

###

 > Hetzner setup:

1. use lb to point traffic to instances.
2. bind postgres container interface to vpc ip.
3. run langflow from container
4. setup caddy for https proxy ???

> GCP

> AWS

> Azure
