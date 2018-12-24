import csv
import sys
import json
import os



    # print(d['conf']['installerConfig']['devices'][0]['properties']['roomName'])
    # print(d)


# "C:\Users\p_sanderson\Documents\Powershell_Crestron_Scripts\devices-ip.csv"

f = open(os.getcwd() + '\\devices-ip.csv', 'r') #open file
try:
    r = csv.reader(f) #init csv reader
    for row in r:
        if row[19] != "" and row[19] != "config_file_name":
            with open(os.getcwd() +'\\'+ row[19]+'.json') as json_data:
                d = json.load(json_data)
            
            if  row[12] != "" and row[12] != "Room_Number":
                if row[11] != "":
                    print("setting room name %s" % row[11] )
                    d['conf']['installerConfig']['devices'][0]['properties']['roomName'] = (row[11]) 

                else:
                    print("setting room number %s" % row[12] )
                    d['conf']['installerConfig']['devices'][0]['properties']['roomName'] = (row[12]) 

            if row[17] != "" and row[17] != "codec_ip":
                print("codec ip %s" % row[17] )
                d['conf']['installerConfig']['devices'][5]['properties']['control']['tcpSshProperties']['address'] = (row[17])

            if row[20] != "" and row[20] != "display_number":
                print("display number %s" % row[22] )
                d['conf']['devices'][4]['modelId'] = int(row[20])
                
            
            with open(os.getcwd() +'\\'+ row[19] + '-' + row[12] + '.json', 'w') as outfile:
                json.dump(d, outfile)
finally:
    f.close() #cleanup
