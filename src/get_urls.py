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

  for tr in tables[0].findAll("tr"):
    tds = tr.findAll("td")
    url = ["","",""]

    urlTail = get_link(tds[0], urlContains)

    # If there's a link, add it & the tds I care about to the urls list
    if (urlTail != ""):
      url[0] = urlBase + urlTail
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

def save_urls(urls):
  f = open("data/urls_data.csv", "w")

  for url in urls:
    f.write(url[0] + "," + url[1] + "," + url[2] + "\n")

  f.close()


def main():
  # TODO: for real, add these to settings...
  sourceURL = "https://briinstitute.com/mw/compare.php"
  baseURL = "https://briinstitute.com/mw/"
  urlContains = "ein"

  urls = get_urls(sourceURL, baseURL, urlContains)
  save_urls(urls)

if __name__ == "__main__":
  main()