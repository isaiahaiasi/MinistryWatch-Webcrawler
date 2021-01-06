import pandas as pd
import requests
from bs4 import BeautifulSoup

# TODO: Create main function

# get_urls
# Returns array of string arrays containing: url, name, sector
# Args:
#   UrlSource: the webpage to pull the table from
#   UrlBase: the links are partial in this case, so append them to a base url
#   UrlContains: a way to specify which links I want, to exclude garbage. Default is blank
#   DataColumns: the name of columns to add to the dataframe (default is "name")
def get_urls(urlSource, urlBase, urlContains = "", dataColumns = ["name"]):
  response = requests.get(urlSource)
  soup = BeautifulSoup(response.text, "html.parser")
  tables = soup.find_all("table")
  
  urls = []
  dataColumns = ["url"] + dataColumns
  df = pd.DataFrame(columns=dataColumns)

  for tr in tables[1].findAll("tr"):
    tds = tr.findAll("td")
    url = ["","",""]
    linkRow = False

    # If there's a link, add it to the urls list
    for cell in tds:
      urlTail = get_link(cell, urlContains)
      if (urlTail != ""):
        url[0] = urlBase + urlTail
        linkRow = True

      # Copy the cells I care about from the tableDF into the df for export
      if linkRow is True:
        url[1] = tds[0].text
        url[2] = tds[1].text
        urls.append(url)
  
  return urls

def get_link(element, urlContains):
  link = ""

  try:
    link = element.find('a')['href']

    if urlContains != "" and not (urlContains in link):
      print("invalid link filtered")

  except:
    pass
    # ISSUE
    # TypeError: 'NoneType' object is not subscriptable 
    # Blame StackOverflow
  
  return link

# url_to_table
# Returns df of data on a charity
# Args:
#   urlData: string array of [url, name, sector]
def url_to_table(urlData):
  # TODO: Pull from options file
  fields = [  
    "net assets", 
    "total revenue", 
    "total contributions", 
    "total expenses",
    "fundraising",
    "program services",
    "total current assets",
    "total assets",
    ]
  fields = set(fields)

  response = requests.get(urlData[0])
  soup = BeautifulSoup(response.text, "html.parser")
  tables = soup.find_all("table")
  
  # Don't try to grab data from pages w/o full dataset
  if len(tables) < 4:
    return None

  htmlDF = pd.read_html(str(tables))[3]
    
  returnDF = pd.DataFrame([["Name", "Sector"]], columns=["_Name", "_Sector"])
  for i in range(2, len(htmlDF.index - 1)):
    if str(htmlDF.loc[i][0]).lower() not in fields:
      # print(str(htmlDF.loc[i][0]) + " not a field")
      continue
    else:
      transposedDF = htmlDF.iloc[i].T
      returnDF = pd.concat([returnDF, transposedDF], ignore_index=True, axis=1)
    
  # Make the first row the headers
  dfHeads = returnDF.iloc[0]
  returnDF = returnDF[1:]
  returnDF.columns = dfHeads

  # Fill in the name/sector column for every row
  returnDF.loc[:,"Name"] = urlData[1]
  returnDF.loc[:,"Sector"] = urlData[2]

  return returnDF

sourceURL = "https://briinstitute.com/mw/compare.php"
baseURL = "https://briinstitute.com/mw/"

# Only grab urls with "ein" in the title (desired url format: "ministry.php?ein=########")
urlContains = "ein"
myURLS = get_urls(sourceURL, baseURL, urlContains)

print("length of url set: " + str(len(myURLS)))
df = url_to_table(myURLS[0])
i = 1
for url in myURLS[1:5]:
  i = i + 1
  print(str(i))
  df = pd.concat([df, url_to_table(url)])

with pd.ExcelWriter("test-excel.xlsx") as writer: # pylint: disable=abstract-class-instantiated
  df.to_excel(writer, sheet_name="Sheet1")

print("number of urls: " + str(len(myURLS)))