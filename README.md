# Unified Auth Gateway: Polyglot SSO

This repository demonstrates a modern, microservice-based authentication pattern using OAuth 2.0 and OpenID Connect (OIDC). It serves as a proof-of-concept for administering a single OAuth 2.0 gateway across a polyglot backend architecture (Python/Django and Java/Spring Boot).

## Architecture

1. **Authorization Server (Django)**: Built with Django and `django-oauth-toolkit`. It handles user login, acts as an OIDC Provider, and issues JWT access tokens securely signed with an RSA private key.
2. **Resource Server 1 (Django API)**: A separate Django service using Django REST Framework. It validates the exact same JWTs mathematically using the Auth Server's public key to protect its `/billing/info/` endpoints.
3. **Resource Server 2 (Spring Boot API)**: A Java Spring Boot application using Spring Security. It pulls the JWKS endpoint from the Auth Server to dynamically validate the JWTs and protect its `/orders/info` endpoints.

## Getting Started Locally

### Prerequisites
- Python 3.10+
- Java 17+

### Running the Services
A convenient script is provided to spin up all three services locally on different ports.
```bash
./scripts/start_all.sh
```

- Auth Server: `http://localhost:8000` (Admin: admin / password123)
- Django API: `http://localhost:8001`
- Spring Boot API: `http://localhost:8080`

### Testing the SSO Flow
1. Login to `http://localhost:8000/admin/oauth2_provider/application/` and create an OAuth2 application (Confidential, Resource owner password-based).
2. Request a JWT from `http://localhost:8000/o/token/`.
3. Use the JWT to hit the Django API:
   `curl -H "Authorization: Bearer <TOKEN>" http://localhost:8001/billing/info/`
4. Use the exact same JWT to hit the Spring Boot API:
   `curl -H "Authorization: Bearer <TOKEN>" http://localhost:8080/orders/info`

## License
MIT License
