import pandas as pd
import requests
from bs4 import BeautifulSoup

# NEED TO LOOK UP HOW TO PROPERLY ORGANIZE PY FILES :/
# Something like "if __name__ == __main__"...
# Currently, code to execute is below function

# TODO: return a DataFrame with a row for each url (currently just returns an array of urls)
# columns: url, dataColumns (default: "name")
# args:
#   UrlSource: the webpage to pull the table from
#   UrlBase: the links are partial in this case, so append them to a base url
#   UrlContains: a way to specify which links I want, to exclude garbage. Default is blank
#   DataColumns: the name of columns to add to the dataframe (default is "name")
#       (unfortunately, don't think I'll be able to make much use of this, bc it only has most recent data, & I want every year)
def get_urls(urlSource, urlBase, urlContains = "", dataColumns = ["name"]):
    response = requests.get(urlSource)
    soup = BeautifulSoup(response.text, "html.parser")
    tables = soup.find_all("table")
    # tableDF = pd.read_html(str(tables[1]),header=0) # use first tr as headers
    # print(tableDF)
    
    urls = [] # instead of a 1d array, I should make a table & add any optional columns (at the very least, including "name")
    dataColumns = ["url"] + dataColumns
    df = pd.DataFrame(columns=dataColumns)

    for tr in tables[1].findAll("tr"):
        tds = tr.findAll("td")
        url = ["","",""]
        linkRow = False

        for cell in tds:
            #if there's a link, add it to the urls list
            urlTail = get_link(cell, urlContains)
            if (urlTail != ""):
                url[0] = urlBase + urlTail
                linkRow = True

        if linkRow is True:
            url[1] = tds[0].text
            url[2] = tds[1].text
            urls.append(url)
    #copy the cells I care about from the tableDF into the df for export

    #print("number of filtered urls: " + str(len(filteredUrls)) + ". eg: " + filteredUrls[0])
    
    return urls

def get_link(element, urlContains):
    link = ""

    try:
        link = element.find('a')['href']

        if urlContains != "" and not (urlContains in link):
            print("invalid link filtered")

    except:
        pass
        #ISSUE
        #TypeError: 'NoneType' object is not subscriptable 
        # (I'm pretty sure the stackoverflow I stole this from added this trycatch to hide the fact that their code is borked. 
        # It's 2am, so I'll figure it out later)
    
    return link

def url_to_table(urlData):
    # the fields I'm interested in
    # (which should just be a list in a json/txt file or something)
    fields = [  "net assets", 
                "total revenue", 
                "total contributions", 
                "total expenses",
                "fundraising",
                "program services",
                "total current assets",
                "total assets",]
    fields = set(fields)
    
    #getting dataframe of table from url could be its own function, I just don't know how to share functions across files yet
    response = requests.get(urlData[0])
    soup = BeautifulSoup(response.text, "html.parser")
    tables = soup.find_all("table")
    
    if len(tables) < 4: # Some pages don't have any tables/data :(
        return None

    htmlDF = pd.read_html(str(tables))[3] # use second tr as headers
    
    returnDF = pd.DataFrame([["Name", "Sector"]], columns=["_Name", "_Sector"])
    for i in range(2, len(htmlDF.index - 1)):
        # see if loc[i][0] matches any field
        if str(htmlDF.loc[i][0]).lower() not in fields:
            # print(str(htmlDF.loc[i][0]) + " not a field")
            continue
        else:
            transposedDF = htmlDF.iloc[i].T
            returnDF = pd.concat([returnDF, transposedDF], ignore_index=True, axis=1)
            # print("found " + str(htmlDF.loc[i][0]))

    
    #make the first row the headers
    dfHeads = returnDF.iloc[0]
    returnDF = returnDF[1:]
    returnDF.columns = dfHeads

    #once I have the data populated from the crawl, 
    #fill in the name/sector column for every row
    returnDF.loc[:,"Name"] = urlData[1]
    returnDF.loc[:,"Sector"] = urlData[2]

    return returnDF

sourceURL = "https://briinstitute.com/mw/compare.php"
baseURL = "https://briinstitute.com/mw/"
urlContains = "ein" #only grab urls that have "ein" in the title (the format url I'm looking for is "ministry.php?ein=########")
myURLS = get_urls(sourceURL, baseURL, urlContains)

print("length of url set: " + str(len(myURLS)))
df = url_to_table(myURLS[0])
i = 1
for url in myURLS[1:]:
    i = i + 1
    print(str(i))
    df = pd.concat([df, url_to_table(url)])

with pd.ExcelWriter("test-excel.xlsx") as writer: # pylint: disable=abstract-class-instantiated
    df.to_excel(writer, sheet_name="Sheet1")

print("number of urls: " + str(len(myURLS)))