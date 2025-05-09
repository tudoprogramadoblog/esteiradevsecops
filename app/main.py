from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

clientes = []

class Cliente(BaseModel):
    nome: str
    email: str
    cpf: str
    data_nascimento: str
    telefone: str

@app.post("/clientes")
def criar_cliente(cliente: Cliente):
    clientes.append(cliente)
    return cliente

@app.get("/clientes")
def listar_clientes():
    return clientes
