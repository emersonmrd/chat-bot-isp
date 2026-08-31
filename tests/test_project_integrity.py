import json
import os
import glob
import pytest

def test_env_example_has_all_required_keys():
    required_keys = [
        "POSTGRES_USER",
        "POSTGRES_PASSWORD",
        "POSTGRES_DB",
        "EVOLUTION_SERVER_URL",
        "EVOLUTION_API_KEY",
        "N8N_WEBHOOK_URL",
        "N8N_ENCRYPTION_KEY",
        "CHATWOOT_FRONTEND_URL",
        "CHATWOOT_SECRET_KEY"
    ]
    with open(".env.example", "r", encoding="utf-8") as f:
        content = f.read()
    
    for key in required_keys:
        assert f"{key}=" in content, f"Chave obrigatoria {key} ausente no .env.example"

def test_workflows_are_valid_json_and_have_nodes():
    workflows = glob.glob("n8n/workflows/*.json")
    for wf in workflows:
        with open(wf, "r", encoding="utf-8") as f:
            data = json.load(f)
            assert "nodes" in data, f"Workflow {wf} deve possuir a chave 'nodes'"
            assert isinstance(data["nodes"], list), f"Chave 'nodes' em {wf} deve ser uma lista"
