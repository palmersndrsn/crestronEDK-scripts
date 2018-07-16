import csv
import sys
import json


with open('C:\\Users\\p_sanderson\\Documents\\All Crestron Code\\APPLE\\WF01\\Pepperdash Code\\Apple T05 Programming\\Apple T07 Programming\\Apple.AC2.T05.Developer.Config_TEMPLATE_v01.06.json') as json_data:
    d = json.load(json_data)
    # print(d['conf']['installerConfig']['devices'][0]['properties']['roomName'])
    # print(d)


# "C:\Users\p_sanderson\Documents\Powershell_Crestron_Scripts\devices-ip.csv"

f = open('C:\\Users\\p_sanderson\\Documents\\Powershell_Crestron_Scripts\\crestronEDK-scripts\\devices-ip.csv', 'r') #open file
try:
    r = csv.reader(f) #init csv reader
    for row in r:
        if  row[17] != "" and row[17] != "program_name":
            
            if  row[11] != "" and row[11] != "Room_Number":
                if row[10] != "":
                    print("setting room name %s" % row[10] )
                    d['conf']['installerConfig']['devices'][0]['properties']['roomName'] = (row[10]) 

                else:
                    print("setting room number %s" % row[11] )
                    d['conf']['installerConfig']['devices'][0]['properties']['roomName'] = (row[11]) 

            if row[16] != "" and row[16] != "codec_ip":
                print("codec ip %s" % row[16] )
                d['conf']['installerConfig']['devices'][4]['properties']['control']['tcpSshProperties']['address'] = (row[16])

            if row[21] != "" and row[21] != "display_number"
                print("display number %s" % row[21] )
                d['conf']['devices'][4]['modelId'] = int(row[21])
                
            
            with open('C:\\Users\\p_sanderson\\Documents\\All Crestron Code\\APPLE\\WF01\\Pepperdash Code\\Apple T05 Programming\\Apple T07 Programming\\Apple.AC2.T05.Developer.Config_TEMPLATE_v01.06-%s.json' % row[11], "w") as outfile:
                json.dump(d, outfile)
finally:
    f.close() #cleanup
