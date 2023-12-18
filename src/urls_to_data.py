import pandas as pd
from pandas.core.indexes.base import Index, InvalidIndexError
import requests
from bs4 import BeautifulSoup
import csv
from datetime import datetime
from logger import Logger

# TODO: Pull from options file
fields = {
    "net assets",
    "total revenue",
    "total contributions",
    "total expenses",
    "fundraising",
    "program services",
    "total current assets",
    "total assets",
}


# different pages have different numbers of tables,
# and the table I want is a different index for each length
def get_df_from_list(dfList):
    dflen = len(dfList)

    if dflen == 2:
        tableIndex = 1
    elif dflen == 3 or dflen == 4:
        tableIndex = 2
    elif dflen > 4:
        tableIndex = 3
    else:
        raise Exception('Unhandled table count: ', dflen)

    # print("tables count:", len(dfList), "tableIndex:", tableIndex)
    return dfList[tableIndex]


def url_to_table(url, name, sector):
    response = requests.get(url)
    soup = BeautifulSoup(response.text, "html.parser")
    tables = soup.find_all("table")

    htmlDFs = pd.read_html(str(tables))

    if len(htmlDFs) < 2:
        raise IndexError("Invalid number of tables (less than 2)")

    htmlDF = get_df_from_list(htmlDFs)

    # seriously no idea what this is doing...
    returnDF = pd.DataFrame([["Name", "Sector"]], columns=["_Name", "_Sector"])
    for i in range(2, len(htmlDF.index - 1)):
        if str(htmlDF.loc[i][0]).lower() in fields:
            transposedDF = htmlDF.iloc[i].T

            # "Year" isn't easily labeled, it pulls from a field ALSO labeled "Net Assets"
            # Having 2 fields causes an error, though, so need to rename it.
            # Pulling it in a smarter way would avoid the need for this
            if transposedDF[0].lower() == 'net assets':
                transposedDF[0] += ' ' + str(i)

            returnDF = pd.concat([returnDF, transposedDF],
                                 ignore_index=True, axis=1)

    # Make the first row the headers
    dfHeads = returnDF.iloc[0]
    returnDF = returnDF[1:]
    returnDF.columns = dfHeads

    # Fill in the name/sector column for every row
    returnDF.loc[:, "Name"] = name
    returnDF.loc[:, "Sector"] = sector

    return returnDF


def get_urls_from_file():
    urls = []
    with open("data/urls_test.csv", "r") as csvUrls:
        for row in csv.DictReader(csvUrls):
            urls.append([row['url'], row['name'], row['sector']])
    return urls


def generate_excel_from_urls(urls, format="csv"):
    df = None

    logger = Logger()

    for (i, [url, name, sector]) in enumerate(urls[1:]):
        row = {
            "url": url,
            "name": name,
            "status": 0,
            "error": None,
        }

        print(i, name)

        try:
            df = pd.concat(
                [df, url_to_table(url, name, sector)], ignore_index=True)
        except (InvalidIndexError, ValueError, IndexError) as err:
            row["status"] = 1
            row["error"] = err
            print(row)

        logger.log(row)

    logger.write(["url", "name", "status", "error"])

    timestamp = datetime.now().strftime('%d-%m-%y_%H:%M:%S')

    if format == 'xlsx':
        df.to_excel(f"data/test-excel-{timestamp}.xlsx", sheet_name="Sheet1")
    else:
        df.to_csv(f"data/test-csv-{timestamp}.csv")


# Grabs urls from data/urls_data.csv, then passes to
def main():
    urls = get_urls_from_file()
    generate_excel_from_urls(urls, "csv")


if __name__ == "__main__":
    main()
