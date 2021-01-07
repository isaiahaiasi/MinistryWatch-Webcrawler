import pandas as pd
import requests
from bs4 import BeautifulSoup
import urls_to_data

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


def main():
  sourceURL = "https://briinstitute.com/mw/compare.php"
  baseURL = "https://briinstitute.com/mw/"

  # Only grab urls with "ein" in the title (desired url format: "ministry.php?ein=########")
  urlContains = "ein"
  myURLS = get_urls(sourceURL, baseURL, urlContains)

  print("length of url set: " + str(len(myURLS)))
  df = urls_to_data.url_to_table(myURLS[0])
  i = 1
  for url in myURLS[1:5]:
    i = i + 1
    print(str(i))
    df = pd.concat([df, urls_to_data.url_to_table(url)])

  with pd.ExcelWriter("test-excel.xlsx") as writer: # pylint: disable=abstract-class-instantiated
    df.to_excel(writer, sheet_name="Sheet1")

  print("number of urls: " + str(len(myURLS)))

if __name__ == "__main__":
  main()