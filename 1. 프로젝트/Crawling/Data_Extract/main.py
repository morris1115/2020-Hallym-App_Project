import requests
from bs4 import BeautifulSoup
import json

## HomePage Croller

def jsonToFile(jsonData, name):
    result = json.dumps(jsonData)
    files = open(name,"w")
    files.write(result)

def Hallym_univ():
    pages = 403
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
    jsonToFile(jsonData,"hallym_univ.json")
    
def Dormitory():
    pages = 50
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
            jsonData["number"].append(i.get_text().strip())
            print(i.get_text())
        for i in posts.find_all("span",{"class":"b-date"}):
            jsonData["number"].append(i.get_text().strip())
        for i in posts.find_all("a"):
            print(i["title"])
            print(i["href"])
        for i in posts.find_all("td",{"class":"b-num-box"}):
            print(i.get_text().strip())
        pages = pages - 10
    jsonToFile(jsonData, "dormitory.json")

def bbs():
    pages = 36
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
    jsonToFile(jsonData,"library.json")
    

def grad():
    pages = 100
    jsonData = {"number":[],"url":[],"date":[],"author":[],"name":[]}
    url = "https://grad.hallym.ac.kr/grad/board/notice.do?mode=list&&articleLimit=10&article.offset=" +str(pages)
    req = requests.get(url)
    html = req.text
    soup = BeautifulSoup(html, 'html.parser')
    posts = soup.find("tr")
    for i in posts.find_all("td"):
        print(i.get_text())