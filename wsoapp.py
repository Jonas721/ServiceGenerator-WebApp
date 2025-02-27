# Requires the Bottle and MySQL libraries
# To use this app:
#   pip install mysql-connector-python
#   pip install flask

from flask import Flask, request
from mysql.connector import connect
import dbconfig
import re

app = Flask(__name__)

con = connect(user=dbconfig.DB_USER, password=dbconfig.DB_PASS, database=dbconfig.DB_NAME, host=dbconfig.DB_HOST) 
cursor = con.cursor() 
con.autocommit = True

svcID = ""
highestSvcID = "0"
SeqNumsToUpdate = []

# sets highestSvcID to the highest current service id in the database so we can increment it ourselves
# and come up with new service ids later
def CalcMaxSvcID():
    global highestSvcID
    cursor.execute("""
        select max(service_id)
        from service;
    """)
    result = cursor.fetchall()
    highestSvcID = str(result)[2:-3]

def selectSvcInfo(toHome: bool) -> list:
    if (toHome):
        cursor.execute("""
            select Svc_DateTime, Theme_Event
            from service;
        """)
    else:
        cursor.execute("""
            select Svc_DateTime, Theme_Event, CONCAT(person.First_Name,' ',person.Last_Name) AS Songleader
            from service 
            LEFT JOIN fills_role
            JOIN person ON fills_role.Person_ID = person.Person_ID
            AND fills_role.Role_Type = 'S' ON service.Service_ID = fills_role.Service_ID;
        """)
    # Retrieve results
    result = cursor.fetchall()

    i = 0
    tableRows = []
    for row in result:
        try:
            (dateTime, theme) = row
        except ValueError:
            (dateTime, theme, songleader) = row
        tableRow = f"""
        <tr  style="color:slate;font-family:verdana;background-color:PaleTurquoise">
            <td>{dateTime}
            <td>{theme}
            """ + ("" if toHome else f"<td>{songleader}") + """
            <td>""" + (HTML_SVC_BTN.format(i) if toHome else HTML_RETURN_BTN) + """
        </tr>
        """
        i += 1
        tableRows.append(tableRow)
    
    return tableRows

def selectSvcItems(svcID: str, congSongOnly: bool = False) -> str:
    global SeqNumsToUpdate

    extraWhereClause = ("" if not congSongOnly else " AND service_item.Event_Type_ID = 5")
    cursor.execute(f"""
        select Seq_Num, event_type.Description, song.Title, CONCAT(person.First_Name,' ',person.Last_Name) AS person_name, Notes
        from service_item
        left join person on service_item.person_id = person.Person_ID
        left join song on service_item.song_id = song.song_ID
        left join event_type on service_item.Event_Type_ID = event_type.Event_Type_ID
        where service_ID = """ + str(svcID) + extraWhereClause + """  
        order by Seq_Num;
    """)
    result = cursor.fetchall()

    # build the dropdown song selection if needed
    options = ""
    if (congSongOnly):
        cursor.execute("SELECT LastUsedDate, Title, song_id FROM songusageview;")
        results = cursor.fetchall()
        for i in range(0, 60):
            try:
                valStr = str((results[i]))
                infoStr = valStr[1:-1]
                valStr = valStr[-3:None].strip()
                valStr = re.findall(r'\d+', valStr)[0]
                infoStr.replace(f"{valStr}","")
                options += str("<option value=\"" + valStr + "\">" + infoStr + "</option>\n")
            except IndexError:
                break
            i += 3

    quoteChar = "\"" #apparently escape characters arent allowed in f strings smh
    i = 0
    output = ""
    beginForm = ""
    endForm = ""
    for row in result:
        if ((congSongOnly) and i == 0):
            beginForm = (f"<form action={quoteChar}/finishCreateService{quoteChar} method={quoteChar}POST{quoteChar}>")
        else:
            beginForm = ""
        if ((congSongOnly) and i == len(result) - 1):
            endForm = ("<button type=\"submit\" style=\"background-color:slate;color:slate;font-family:verdana;\"> Finalize </button></form>")

        (seqNum, eventType, songTitle, personName, notes) = row
        if (congSongOnly):
            SeqNumsToUpdate.append(seqNum)
        tableRow = f"""
        <tr  style="color:slate;font-family:verdana;background-color:PaleTurquoise">
            {beginForm}
            <td>{seqNum}
            <td>{eventType}
            <td>{(songTitle if (not congSongOnly) else (f"<select name={quoteChar}song{seqNum}{quoteChar} id={quoteChar}song{seqNum}{quoteChar}>" + options + "</select>"))}
            <td>{personName}
            <td>{notes}
        </tr>{endForm}
        """
        i += 1
        output += tableRow
    
    return output

@app.route('/')
def home():
    tableRowsStr = ""
    tableRows = selectSvcInfo(True)
    for i in range(0, len(tableRows)):
        tableRowsStr += tableRows[i]
    return HTML_SVC_LIST.format(tableRowsStr)

@app.route('/service', methods=['POST'])
def service():
    global svcID
    svcNum = int(request.form['svcNum'])
    svcTableRows = selectSvcInfo(False)
    #svcTableRows.reverse()
    svcTableRow = svcTableRows[svcNum]
    htmlStr = HTML_SVC_LIST[24:-24].replace("Link to Service", "Songleader\n<td>")
    htmlStr = htmlStr.replace("Service Order Generator", "Service Items")

    cursor.execute("""
        SELECT service_ID from service;
    """)
    results = cursor.fetchall()
    svcID = str(results[svcNum])[1:-2]
    
    #make the list of songleaders
    cursor.execute("""
        SELECT CONCAT(person.First_Name,' ',person.Last_Name) as Songleader
        from fills_role
        JOIN person ON fills_role.Person_ID = person.Person_ID
        where role_type = 'S'
    """)
    results = cursor.fetchall()
    songleadersHTML = ""
    for sl in results:
        songleadersHTML += HTML_FORM_OPTIONS.format(str(sl)[1:-2])

    return ("<html><center>" + htmlStr.format(svcTableRow) + HTML_SVC_ITEMS.format(selectSvcItems(svcID)) + HTML_NEW_SVC_FORM.format(songleadersHTML) + "</center></html>")

@app.route('/createService', methods=['POST'])
def createService():
    global svcID
    global highestSvcID
    dateTime = request.form.get('dateTime')
    theme = request.form.get('theme')
    songleader = request.form.get('songleader')

    #handle blank and poorly formatted junk
    if dateTime == "":
        return HTML_ERROR.format("Date/Time cannot be blank") + "<center>" + HTML_RETURN_BTN + "</center>"
    r = re.compile('\d\d\d\d-\d{1,2}-\d{1,2}\s*\d+:\d+:\d+')
    if r.match(str(dateTime)) is None:
        return HTML_ERROR.format("Date/Time is not in the correct format") + "<center>" + HTML_RETURN_BTN + "</center>"
    if theme == "":
        cursor.execute("""
        SELECT theme_event from service
        WHERE service_ID = '{0}';
        """.format(svcID))
        result = cursor.fetchall()
        theme = str(result)[1:-2]

    #check that dateTime is not used for another service already
    cursor.execute("""
        SELECT svc_dateTime
        from service
        where svc_DateTime = %s;
    """, (dateTime,))
    results = cursor.fetchall()
    if (results):
        return HTML_ERROR.format("There is already a service at that time") + "<center>" + HTML_RETURN_BTN + "</center>"
    # get the person id of songleader
    cursor.execute("""
    SELECT person.Person_ID
    from fills_role
    JOIN person ON fills_role.Person_ID = person.Person_ID
    where CONCAT(person.First_Name,' ',person.Last_Name) = %s AND fills_role.Service_ID = %s;
    """, (songleader, svcID))
    results = cursor.fetchall()
    personID = "-1"
    if (len(results) > 0):
        personID = str(results)[1:-2]

    # finally call the stored procedure
    highestSvcID = str(int(highestSvcID) + 1)
    if highestSvcID.isdigit() and svcID.isdigit():
        cursor.callproc('create_service', [dateTime, theme, personID, highestSvcID, svcID])
    else:
        print("Error: highestSvcID and svcID should be integers.")

    return ("""<html><center><body style="background-color:CadetBlue;">
            <h1 style="color:snow;font-family:verdana;">Assign Songs to New Service</h1>""" 
            + HTML_SVC_ITEMS.format(selectSvcItems(svcID, True)) + "</body></center></html>")

@app.route('/finishCreateService', methods=['POST'])
def finishCreateService():
    global SeqNumsToUpdate

    for row in SeqNumsToUpdate:
        songID = request.form.get('song' + str(row))
        cursor.execute("""
            update service_item
            set song_id = %s
            where service_id = %s and seq_num = %s;
        """, (songID, str(highestSvcID), row))
    SeqNumsToUpdate.clear()

    return ("""<html><center><body style="background-color:CadetBlue;">
            <h1 style="color:snow;font-family:verdana;">Service Creation Success!</h1>
            <p style="font-size:100px">&#129395;</p>
            </body></center></html>""" + HTML_RETURN_BTN)

HTML_SVC_LIST = """
    <html>
    <center>
        <body style="background-color:CadetBlue;">
            <title>App Dev II - Jonas Stamper</title>
            <h1 style="color:snow;font-family:verdana;">Service Order Generator</h1>
            <table border='1'>
            <tr style="color:slate;font-family:verdana;font-weight:bold;background-color:PaleTurquoise">
                <td>Service Date
                <td>Theme
                <td>Link to Service
            </tr>
            {0}
            </table>
        </body>
        </center>
    </html>"""

HTML_SVC_BTN = """
    <form action="/service" method="post">
        <input type="hidden" name="svcNum" value="{0}">
        <button type="submit" style="background-color:slate;color:slate;font-family:verdana;">View service {0}</button>
    </form>
"""

HTML_RETURN_BTN = """
    <form action="/">
        <button type="submit" style="background-color:slate;color:slate;font-family:verdana;"> Return home </button>
    </form>
"""

HTML_SVC_ITEMS = """
    &nbsp;
    <table border='1'>
    <tr style="color:slate;font-family:verdana;font-weight:bold;background-color:PaleTurquoise">
        <td>Sequence Number
        <td>Event Type
        <td>Song Title
        <td>Person Name
        <td>Notes
    </tr>
    {0}
    </table>
    """

HTML_NEW_SVC_FORM = """
    &nbsp;
    <h2 style="color:snow;font-family:verdana;">Create a New Service Based on this Template</h2>
    <table border='1'>
    <tr style="color:slate;font-family:verdana;font-weight:bold;background-color:PaleTurquoise">
        <td>Date/Time
        <td>Theme
        <td>Songleader
        <td>
    </tr>
    <tr style="color:slate;font-family:verdana;background-color:PaleTurquoise">
        <td> <form action="/createService" method="post"> <input type="text" id="dateTime" name="dateTime" placeholder="yyyy-mm-dd hr:min:sec">
        <td> <input type="text" id="theme" name="theme">
        <td> {0}
        <td> <button type="submit" style="background-color:slate;color:slate;font-family:verdana;"> Create </button> </form>
    </tr>
    </table>
    """

HTML_FORM_OPTIONS = """
    <input type="radio" id="songleader" name="songleader" value="{0}">
    <label for="{0}"> {0}</label><br>
"""

HTML_DROPDOWN = """
    <form action="/finishCreateService" method="POST">
        <select name="cars" id="cars">
            <option value="volvo">Volvo</option>
            <option value="saab">Saab</option>
            <option value="mercedes">Mercedes</option>
            <option value="audi">Audi</option>
        </select>
        <button type="submit" style="background-color:slate;color:slate;font-family:verdana;"> Finalize </button>
    </form>
"""

HTML_ERROR = """
    <html>
    <center>
    <body style="background-color:CadetBlue;">
        <h1 style="color:snow;font-family:verdana;">ERROR!</h1>
        <h2 style="color:snow;font-family:verdana;">{0}</h2>
        <p style="font-size:100px">&#128557;</p>
    </body>
    </center>
    <html>
    """

# Launch the local web server
if __name__ == "__main__":
    CalcMaxSvcID()
    app.run(host='localhost', debug=True)