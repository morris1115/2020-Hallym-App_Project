import json
from flask import Flask
app = Flask (__name__)

def fileToJson(fileName):
    target = "../croller/parsing_data/" + fileName
    with open(target) as json_file:
        json_data = json.load(json_file)
        return str(json_data)

@app.route('/adv')
def getAdv():
    json = fileToJson("Adv.json")
    return json
 
@app.route('/bio')
def getBio():
    json = fileToJson("Bio.json")
    return json

@app.route('/bioMedical')
def getBioMedical():
    json = fileToJson("Biomedical.json")
    return json
 
@app.route('/Biz')
def getBiz():
    json = fileToJson("Biz.json")
    return json

@app.route('/Chem')
def getChem():
    json = fileToJson("Chem.json")
    return json

@app.route('/China')
def getChina():
    json = fileToJson("China.json")
    return json

@app.route('/Data')
def getData():
    json = fileToJson("Data.json")
    return json

@app.route('/Dell')
def getDell():
    json = fileToJson("Dell.json")
    return json

@app.route('/Econo')
def getEcono():
    json = fileToJson("Econo.json")
    return json

@app.route('/Environ')
def getEnviron():
    json = fileToJson("Environ.json")
    return json

@app.route('/Fin')
def getFin():
    json = fileToJson("Fin.json")
    return json

@app.route('/Food')
def getFood():
    json = fileToJson("Food.json")
    return json

@app.route('/Future')
def getFuture():
    json = fileToJson("Future.json")
    return json

@app.route('/Global')
def getGlobal():
    json = fileToJson("Global.json")
    return json

@app.route('/Honors')
def getHoners():
    json = fileToJson("Honors.json")
    return json

@app.route('/Japanese')
def getJapanese():
    json = fileToJson("Japanese.json")
    return json

@app.route('/Korean')
def getKorean():
    json = fileToJson("Korean.json")
    return json

@app.route('/Law')
def getLaw():
    json = fileToJson("Law.json")
    return json

@app.route('/Media')
def getMedia():
    json = fileToJson("Media.json")
    return json

@app.route('/Nurse')
def getNurse():
    json = fileToJson("Nurse.json")
    return json

@app.route('/Politics')
def getPolitics():
    json = fileToJson("Politics.json")
    return json

@app.route('/Psy')
def getPsy():
    json = fileToJson("Psy.json")
    return json

@app.route('/Russian')
def getRussian():
    json = fileToJson("Russian.json")
    return json

@app.route('/Slp')
def getSlp():
    json = fileToJson("Slp.json")
    return json

@app.route('/Soc')
def getSoc():
    json = fileToJson("Soc.json")
    return json

@app.route('/Sports')
def getSports():
    json = fileToJson("Sports.json")
    return json

@app.route('/Welfare')
def getWelfare():
    json = fileToJson("Welfare.json")
    return json
