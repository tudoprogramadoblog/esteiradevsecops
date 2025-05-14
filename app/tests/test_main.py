from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_criar_cliente():
    response = client.post("/clientes", json={
        "nome": "João",
        "email": "joao@email.com",
        "cpf": "12345678900",
        "data_nascimento": "1990-01-01",
        "telefone": "11999999999"
    })
    assert response.status_code == 200
    assert response.json()["nome"] == "João"