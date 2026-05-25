import json
import glob
import os

all_data = []

files = glob.glob("part*.json")
def get_part_num(filename):
    return int(filename.replace("part", "").replace(".json", ""))

files.sort(key=get_part_num)

for f in files:
    with open(f, 'r', encoding='utf-8') as file:
        try:
            data = json.load(file)
            for item in data:
                if 'qa' in item and isinstance(item['qa'], list) and len(item['qa']) > 0:
                    for qa_item in item['qa']:
                        if 'q' in qa_item and 'a' in qa_item:
                            all_data.append({
                                "title": qa_item["q"],
                                "content": qa_item["a"]
                            })
                elif 'question' in item and 'answer' in item:
                    all_data.append({
                        "title": item["question"],
                        "content": item["answer"]
                    })
        except Exception as e:
            print(f"Error in {f}: {e}")

with open("combined.json", "w", encoding="utf-8") as out:
    json.dump(all_data, out, ensure_ascii=False, indent=2)

print(f"Total entries: {len(all_data)}")
