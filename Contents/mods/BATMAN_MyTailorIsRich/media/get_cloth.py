import re


def get_module_name(file_content):
    match = re.search(r'^module\s+(\w+)\s*{', file_content, re.MULTILINE)
    if match:
        return match.group(1)
    return None


def is_clothing_valid(item_details):
    return "Helmet" not in item_details


def check_clothing_items(file_path):
    # Lecture du fichier entier
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()

    module_name = get_module_name(content)
    # Recherche de tous les blocs d'items
    items_without_fabric_type = []
    item_blocks = re.findall(r'item\s+(.*?)\s*\{([^}]*?)\}', content, re.DOTALL)

    # Analyse de chaque bloc d'item
    for item_name, item_details in item_blocks:
        if module_name is not None:
            item_name = f"{module_name}.{item_name}"
        if 'Type = Clothing' in item_details and 'FabricType =' not in item_details and is_clothing_valid(item_details):
            items_without_fabric_type.append(item_name)

    return items_without_fabric_type


# Utilisation de la fonction
if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        print("Usage: python script.py <file_path>")
    else:
        file_path = sys.argv[1]
        result = check_clothing_items(file_path)
        print("Items of type 'Clothing' without 'FabricType':")
        for item in result:
            print(f'"{item}",')
