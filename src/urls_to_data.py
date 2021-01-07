import pandas as pd
import requests
from bs4 import BeautifulSoup
import csv

# Returns: dataframe concatenated from each df returned from url_to_table
# urls: a list of string[] in the form [url, add'l columns..(eg, name, sector)]
def urls_to_data(urls):

    pass

# url: a string[] in the form [url, add'l columns..(eg, name, sector)]
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

def get_urls_from_file():
  urls = []

  with open("data/urls_data.csv","r") as csvUrls:
    reader = csv.reader(csvUrls)
    for row in reader:
      urls.append([row[0], row[1], row[2]])

  return urls

def generate_excel_from_urls(urls):
  df = url_to_table(urls[0])

  i = 0
  for url in urls[1:]:
    i = i + 1
    print(str(i))
    df = pd.concat([df, url_to_table(url)])

  with pd.ExcelWriter("data/test-excel-001.xlsx") as writer: # pylint: disable=abstract-class-instantiated
    df.to_excel(writer, sheet_name="Sheet1")


# Grabs urls from data/urls_data.csv, then passes to
def main():
  urls = get_urls_from_file()
  generate_excel_from_urls(urls)

if __name__ == "__main__":
  main()