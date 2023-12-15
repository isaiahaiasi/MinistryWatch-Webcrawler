import requests
import os
import csv
from bs4 import BeautifulSoup
from datetime import datetime

# get_urls
# Returns array of string arrays containing: url, name, sector
# Args:
#   UrlSource: the webpage to pull the table from
#   UrlBase: the links are partial in this case, so append them to a base url
#   UrlContains: a way to specify which links I want, to exclude garbage. Default is blank
#   DataColumns: the name of columns to add to the dataframe (default is "name")
def get_urls(urlSource, urlBase, urlContains="", dataColumns=["name"]):
    dataColumns = ["url"] + dataColumns
    response = requests.get(urlSource)
    tables = BeautifulSoup(response.text, "html.parser").find_all("table")

    urls = []

    for tr in tables[0].findAll("tr"):
        [name_td, sector_td, *_] = tr.findAll("td")
        urlTail = get_link(name_td, urlContains)

        if (urlTail):
            url = urlBase + urlTail
            urls.append([url, name_td.text, sector_td.text])

    return urls


def get_link(element, urlContains=""):
    # if element does not have an <a> tag, return nothing
    try:
        link = element.find('a')['href']
    except TypeError:
        # TypeError: 'NoneType' object is not subscriptable
        print("No <a> tag in element", element)
        return None

    # if the url does not contain the filter string, return nothing
    if urlContains != "" and not (urlContains in link):
        print(f"invalid link filtered: {link}")
        return None

    return link

def save_urls(urls):
    # make sure directory exists
    if not os.path.exists("data"):
        os.mkdir("data")

    # write urls data to csv
    fname = f"data/urls__{datetime.now().strftime('%d-%m-%y_%H:%M:%S')}.csv"
    with open(fname, "w") as f:
        csvwriter = csv.writer(f, quoting=csv.QUOTE_MINIMAL)
        csvwriter.writerow(['url', 'name', 'sector'])
        csvwriter.writerows(urls)


def main():
    # TODO: for real, add these to settings...
    sourceURL = "https://briinstitute.com/mw/compare.php"
    baseURL = "https://briinstitute.com/mw/"
    urlContains = "ein"

    urls = get_urls(sourceURL, baseURL, urlContains)
    save_urls(urls)


if __name__ == "__main__":
    main()
