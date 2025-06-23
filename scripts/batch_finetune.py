import os
import subprocess

AGENTS = [
    "zara", "tita_vp_administrativo", "tom", "sofia_success", "sofia_mentora", "sam", "ray", "oliver", "noah",
    "milo_documentador", "nia", "mila", "mia", "maya", "max", "luna_inversionista", "lucas", "liam_inversionista",
    "leo", "julia", "kai", "jack", "isa", "gaby", "goga_mentora", "eva_vpmarketing", "ethan_soporte", "ema_producto",
    "dylan", "diego_inversionista", "dany_tecnicocloud", "ben", "andu", "ana", "alex", "Modelfile_GER_DE_Zoe",
    "Modelfile_GER_DE_Elsy", "Modelfile_GER_DE_Bella", "Modelfile_Adan_CEO"
]

for agent in AGENTS:
    print(f"Fine-tuning {agent}...")
    subprocess.run([
        "python", "scripts/finetune_model.py",
        "--agent_name", agent
    ])
