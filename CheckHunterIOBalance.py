#!/usr/bin/python

import sys
import requests
import datetime

header = '''
Hunter.io balance
------------------------------------'''
print(header)

#paste in your api key
api_key=""

#get account data for API status
request = requests.get('https://api.hunter.io/v2/account?api_key=' + api_key)

#get account data in JSON form
json_data = requests.get('https://api.hunter.io/v2/account?api_key=' + api_key).json()

#print(request.status_code)

#check if connectivity is up or down
if request.status_code == 200:
	print('Query: ' + str(request.status_code) + ' Success, API up!')
elif request.status_code == 401:
	print('API key invalid, check account or typo possibly')
	sys.exit("")
elif request.status_code == 429:
	print('Monthly quota reached')
	sys.exit("")
else:
	print('Query: Oops, API Down! Check connectivity to Hunter.io')
	sys.exit("")

#put account data in to variables
firstName = json_data['data']['first_name']
lastName = json_data['data']['last_name']
emailAddress = json_data['data']['email']
requestsAvailable = json_data['data']['calls']['available']
requestsUsed = json_data['data']['calls']['used']
resetDate = json_data['data']['reset_date']
planType = json_data['data']['plan_name']

#calculate days remaining before reset
#get todays date
today = datetime.datetime.today()
#convert account reset date from string to datetime
resetDatetoDatetime = datetime.datetime.strptime(resetDate, "%Y-%m-%d")
#calculate days to reset
daystoReset = resetDatetoDatetime - today

#print the loot
print("")
print('Name:			' + firstName + " " + lastName)
print('Account:		' + emailAddress)
print('Account Type:		' + planType)
print('Requests Remaining:	' + str(requestsAvailable))
print('Requests Used:		' + str(requestsUsed))
print('Reset Date:		' + resetDate)
print('Days until reset:	' + str(daystoReset.days))
sys.exit()
