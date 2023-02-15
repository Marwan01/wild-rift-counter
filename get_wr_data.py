import requests
import json


def get_ugly_wr_data(url):
    ugly_wr_data = requests.get(url).text
    return json.loads(ugly_wr_data)

def clean_wr_data(ugly_wr_data):
    # Cleaning
    # Get rid of everything that does not have "champion" or "image.url"
    champion_list = ugly_wr_data["result"]["data"]["allContentstackChampions"]["nodes"][0]["championList"]
    clean_champion_list = []
    for champion in champion_list:
        clean_champion_list.append({"name":champion["name"],"image":champion["image"]["url"]})
    return clean_champion_list

def get_wr_data():
    url = 'https://wildrift.leagueoflegends.com/page-data/en-us/champions/page-data.json'
    ugly_data = get_ugly_wr_data(url)
    clean_data = clean_wr_data(ugly_data)
    with open('ugly_wr_data.json', 'w', encoding='utf-8') as f:
        json.dump(clean_data, f, ensure_ascii=False, indent=4)
