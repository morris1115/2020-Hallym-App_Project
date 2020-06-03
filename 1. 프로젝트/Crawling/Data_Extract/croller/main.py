import requests
from bs4 import BeautifulSoup
import json

## HomePage Croller


pages = {
    "Korean": 20, 
    "Dell": 220, 
    "China":80, 
    "Japanese":40 , 
    "Russian": 50, 
    "Psy": 100,  
    "Soc": 110,
    "Welfare": 50,
    "Politics": 110,
    "Adv" : 190,
    "Law" : 40,
    "Econo": 80,
    "Biz": 120 ,
    "Environ" : 20,
    "Sports" : 20,
    "Global" : 80,
    "Honors" : 50,
    "Media" : 60,
    "Data" : 100,
    "Future" : 20,
    "Chem": 0,
    "Fin": 18,
    "Bio": 5,
    "Biomedical": 3,
    "Food" : 23,
    "Slp" : 0,
    "Nurse" : 67,
    "Nano" : 3,
    "Sw" : 5,
    "Hlsw" : 14
}

with open('./config2.json') as json_file:
    json_data = json.load(json_file)



middleParts = "?mode=list&&articleLimit=10&article.offset="


def jsonToFile(jsonData, name):
    with open(name, 'w', encoding='UTF-8') as file:
        file.write(json.dumps(jsonData, ensure_ascii=False))

def Hallym_univ():
    pages = 403
    result = []
    jsonTemp = {}
    jsonData = {"number":[],"url":[],"date":[],"author":[],"name":[]}
    while (True):
        if(pages < 0):
            break
        url = "https://www.hallym.ac.kr/hallym_univ/sub05/cP3/sCP1.html?nttId=0&bbsTyCode=BBST00&bbsAttrbCode=BBSA03&authFlag=N&pageIndex="+str(pages)+"&searchType=0&searchWrd="
        req = requests.get(url)
        html = req.text
        soup = BeautifulSoup(html, 'html.parser')
        posts = soup.find("ul", {"class" : "tbl-body"})
        
        for i in posts.find_all("span",{"class":"col col-1 tc"}):
            jsonData["number"].append(i.get_text())

        for i in posts.find_all("span",{"class":"col col-3 tc"}):
            jsonData["author"].append(i.get_text()[3:])

        for i in posts.find_all("span",{"class":"col col-5 tc"}):
            jsonData["date"].append(i.get_text()[3:])

        for i in posts.find_all("a"):
            jsonData["url"].append(i['href'])
            jsonData["name"].append(i.get_text().strip())
        pages = pages - 1
    for i in range(len(jsonData["number"])):
        jsonTemp["number"] = jsonData["number"][i]
        jsonTemp["url"] = "https://www.hallym.ac.kr/hallym_univ/sub05/cP3/sCP1.html" + jsonData["url"][i]
        jsonTemp["date"] = jsonData["date"][i]
        jsonTemp["author"] = jsonData["author"][i]
        jsonTemp["name"] = jsonData["name"][i]
        result.append(jsonTemp)
        jsonTemp = {}
    jsonToFile(result,"./parsing_data/hallym_univ.json")
    
def Dormitory():
    pages = 50
    result = []
    jsonTemp = {}
    jsonData = {"number":[],"url":[],"date":[],"author":[],"name":[]}
    while(True):
        if(pages < 0):
            break
        url ="https://dorm.hallym.ac.kr/dormitory/committee/notice1.do?mode=list&&articleLimit=10&article.offset="+str(pages)
        req = requests.get(url)
        html = req.text
        soup = BeautifulSoup(html, 'html.parser')
        posts = soup.find("tbody")
        for i in posts.find_all("span",{"class":"b-writer"}):
            jsonData["author"].append(i.get_text().strip())
            print(i.get_text())
        for i in posts.find_all("span",{"class":"b-date"}):
            jsonData["date"].append(i.get_text().strip())
        for i in posts.find_all("a"):
            jsonData["name"].append(i["title"])
            jsonData["url"].append(i["href"])
            print(i["title"])
            print(i["href"])
        for i in posts.find_all("td",{"class":"b-num-box"}):
            jsonData["number"].append(i.get_text().strip())
            print(i.get_text().strip())
        pages = pages - 10
    for i in range(len(jsonData["number"])):
        jsonTemp["number"] = jsonData["number"][i]
        jsonTemp["url"] = "https://dorm.hallym.ac.kr/dormitory/committee/notice1.do" + jsonData["url"][i]
        jsonTemp["date"] = jsonData["date"][i]
        jsonTemp["author"] = jsonData["author"][i]
        jsonTemp["name"] = jsonData["name"][i]
        result.append(jsonTemp)
        jsonTemp = {}
    jsonToFile(result, "./parsing_data/dormitory.json")

def bbs():
    pages = 36
    result = []
    jsonTemp = {}
    jsonData = {"number":[],"url":[],"date":[],"author":[],"name":[]}
    while(True):
        if(pages < 0):
            break
        url = "https://library.hallym.ac.kr/bbs/list/4?pn="+str(pages)
        req = requests.get(url)
        html = req.text
        soup = BeautifulSoup(html, 'html.parser')
        posts = soup.find("tbody")
        for i in posts.find_all("td",{"class":"num"}):
            jsonData["number"].append(i.get_text().strip())
        for i in posts.find_all("td",{"class":"writer"}):
            jsonData["author"].append(i.get_text().strip())
        for i in posts.find_all("td",{"class":"insert_date"}):
            jsonData["date"].append(i.get_text().strip())
        for i in posts.find_all("a"):
            jsonData["url"].append(i["href"])
            jsonData["name"].append(i.get_text().strip())
        pages = pages - 1
    for i in range(len(jsonData["url"])):
        jsonTemp["number"] = jsonData["number"][i]
        jsonTemp["url"] = "https://library.hallym.ac.kr/bbs/list/4" + jsonData["url"][i]
        jsonTemp["date"] = jsonData["date"][i]
        jsonTemp["author"] = jsonData["author"][i]
        jsonTemp["name"] = jsonData["name"][i]
        result.append(jsonTemp)
        jsonTemp = {}
    jsonToFile(result,"./parsing_data/library.json")
    


def grad():
    pages = 100
    result = []
    jsonTemp = {}
    jsonData = {"number":[],"url":[],"date":[],"author":[],"name":[]}
    while(True):
        if(pages < 0):
                break
        url = "https://grad.hallym.ac.kr/grad/board/notice.do?mode=list&&articleLimit=10&article.offset=" +str(pages)
        req = requests.get(url)
        html = req.text
        soup = BeautifulSoup(html, 'html.parser')
        posts = soup.find("tbody")
        for i in posts.find_all("td",{"class":"b-num-box"}):
            jsonData["number"].append(i.get_text().strip())

        for i in posts.find_all("td"):
            if len(i.get_text().strip()) == 8:
                jsonData["date"].append(i.get_text().strip())

        for i in posts.find_all("a"):
            jsonData["url"].append("https://grad.hallym.ac.kr/grad/board/notice.do"+i["href"])
            jsonData["name"].append(i["title"])
            jsonData["author"].append("대학원")
        pages = pages - 10
    for i in range(len(jsonData["number"])):
        jsonTemp["number"] = jsonData["number"][i]
        jsonTemp["url"] = jsonData["url"][i]
        jsonTemp["date"] = jsonData["date"][i]
        jsonTemp["author"] = jsonData["author"][i]
        jsonTemp["name"] = jsonData["name"][i]
        result.append(jsonTemp)
        jsonTemp = {}
    jsonToFile(result, "./parsing_data/grad.json")
        #jsonToFile(jsonData,"grad.json")



def fileParser(data, data2, mid):
    totalKey = data.keys()
    result = []
    jsonTemp = {}
    jsonData = {"number":[],"url":[],"date":[],"author":[],"name":[]}
    for k in totalKey:
        print(k)
        pages = data2[k]
        while(True):
            if(pages < 0):
                break
            target = data[k] + mid + str(pages)
            req = requests.get(target)
            html = req.text
            soup = BeautifulSoup(html, 'html.parser')
            posts = soup.find("tbody")
            for i in posts.find_all("td",{"class":"b-num-box"}):
                print(i.get_text().strip())
                jsonData["number"].append(i.get_text().strip())

            for i in posts.find_all("td"):
                if len(i.get_text().strip()) == 8:
                    jsonData["date"].append(i.get_text().strip())

            for i in posts.find_all("a"):
                jsonData["url"].append(data[k]+i["href"])
                try:
                    jsonData["name"].append(i["title"])
                except KeyError:
                    jsonData["name"].append(i.get_text().strip())
                jsonData["author"].append(str(k))
            
            if(pages % 10 == 0):
                pages = pages - 10
            else:
                pages = pages - 1
        for i in range(len(jsonData["number"])):
            jsonTemp["number"] = jsonData["number"][i]
            jsonTemp["url"] = jsonData["url"][i]
            jsonTemp["date"] = jsonData["date"][i]
            jsonTemp["author"] = jsonData["author"][i]
            jsonTemp["name"] = jsonData["name"][i]
            result.append(jsonTemp)
            jsonTemp = {}        
        jsonToFile(result, "./parsing_data/"+ str(k) + ".json")
        jsonData = {"number":[],"url":[],"date":[],"author":[],"name":[]}
        result = []

def nano():
    pages = 3
    result = []
    jsonTemp = {}
    jsonData = {"number":[],"url":[],"date":[],"author":[],"name":[]}
    while (True):
        if(pages < 0):
            break
        url = "https://nano.hallym.ac.kr/news/notice.html;jsessionid=86327E470AAD8F3E218E29C0CEDEAAE4?nttId=0&bbsTyCode=BBST00&bbsAttrbCode=BBSA03&authFlag=N&pageIndex="+str(pages)+"&searchType=0&searchWrd="
        req = requests.get(url)
        html = req.text
        soup = BeautifulSoup(html, 'html.parser')
        posts = soup.find("ul", {"class" : "tbl-body"})
        print(posts)
        for i in soup.find_all("span",{"class":"col col-1 tc"}):
            jsonData["number"].append(i.get_text())

        for i in soup.find_all("span",{"class":"col col-2 dot"}):
            jsonData["name"].append(i.get_text()[3:].strip())

        for i in soup.find_all("span",{"class":"col col-5 tc"}):
            jsonData["date"].append(i.get_text()[3:])

        for i in soup.find_all("a"):
            jsonData["url"].append(i['href'])
            jsonData["author"].append(i.get_text().strip())
        pages = pages - 1
    for i in range(len(jsonData["number"])):
        jsonTemp["number"] = jsonData["number"][i]
        jsonTemp["url"] = "https://nano.hallym.ac.kr/news/notice.html" + jsonData["url"][i]
        jsonTemp["date"] = jsonData["date"][i]
        jsonTemp["author"] = jsonData["author"][i]
        jsonTemp["name"] = jsonData["name"][i]
        result.append(jsonTemp)
        jsonTemp = {}
    jsonToFile(result,"./parsing_data/nano.json")

#Hallym_univ()
#bbs()
#Dormitory()    
#grad()
#nano()
fileParser(json_data, pages, middleParts)

