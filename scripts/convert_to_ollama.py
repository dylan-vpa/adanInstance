import argparse
import os

AGENTS = [
    "zara", "tita_vp_administrativo", "tom", "sofia_success", "sofia_mentora", "sam", "ray", "oliver", "noah",
    "milo_documentador", "nia", "mila", "mia", "maya", "max", "luna_inversionista", "lucas", "liam_inversionista",
    "leo", "julia", "kai", "jack", "isa", "gaby", "goga_mentora", "eva_vpmarketing", "ethan_soporte", "ema_producto",
    "dylan", "diego_inversionista", "dany_tecnicocloud", "ben", "andu", "ana", "alex", "Modelfile_GER_DE_Zoe",
    "Modelfile_GER_DE_Elsy", "Modelfile_GER_DE_Bella", "Modelfile_Adan_CEO"
]

def convert(agent):
    # ...existing code for conversion...
    print(f"Converting {agent} to Ollama format...")
    # Placeholder: implement your conversion logic here

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--agent_name')
    parser.add_argument('--all', action='store_true')
    args = parser.parse_args()

    if args.all:
        for agent in AGENTS:
            convert(agent)
    elif args.agent_name:
        convert(args.agent_name)
    else:
        print("Specify --agent_name or --all")

if __name__ == "__main__":
    main()
