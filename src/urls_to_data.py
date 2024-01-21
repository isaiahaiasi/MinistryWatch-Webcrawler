import requests
from bs4 import BeautifulSoup
import csv

# TODO: Instead of using this, rewrite to dump everything in a local SQLLite DB.
# The flow then becomes:
# - Get urls
# - Go to each URL, dump data for each year as a row in the table
# - Use the table data to build the CSV/Excel file

'''
CHARITY INFO:
table:
    Name (PK)
    Sector
    FiscalYearEnd

- Get name from text
- Get sector from text
- Get Fiscal Year End from text


FINANCIALS
table:
    CharityID
    Year
    (every financials row...)
    PRIMARY KEY (CharityID, Year)
- Add 

COMPENSATION:
table:
    CharityID
    Name
    Title
    Compensation
    "As of" Date
- Get compensation "as of" date from text
'''

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

class MinistryCrawler:
    def __init__(self):
        self.charities = []
        self.finances = []
        self.compensations = []

    def get_compensation_data(self, charity, soup_page):
        comp_table = (soup_page
                      .find('h2', string="Compensation")
                      .find_next('table')
        )

        if not comp_table:
            return -1

        comp_date = (soup_page.find(string=lambda t: "Compensation data as of" in t)
                    .split(':')[1]
                    .strip()
        )

        rows = comp_table.find_all("tr")[1:]

        for row in rows:
            name, title, compensation = [td.text for td in row.find_all("td")]
            self.compensations.append({
                'ein': charity['ein'],
                'date': comp_date,
                'name': name,
                'title': title,
                'compensation': compensation,
            })
        
        return len(rows)

    def get_financial_data(self):
        # TODO
        pass

    def get_charity_data(self):
        for charity in self.charities:
            res = requests.get(charity['url'])
            soup = BeautifulSoup(res.text, "html.parser")

            charity['fye'] = (soup.find(string=lambda t: "Fiscal year end:" in t)
                    .split(':')[1]
                    .strip()
            )

            # Don't really need to re-run
            self.get_compensation_data(charity, soup)

            self.get_financial_data()

    def load_charities_from_file(self, filepath):
        with open(filepath, "r") as csv_urls:
            for charity in csv.DictReader(csv_urls):
                self.charities.append(charity)
    
    def write_charity_data_to_file(self):
        with open("data/compensation.csv", "w") as comp_fp:
            writer = csv.DictWriter(
                comp_fp,
                fieldnames=["ein", "date", "name", "title", "compensation"],
            )
            writer.writeheader()
            writer.writerows(self.compensations)

def main():
    crawler = MinistryCrawler()
    crawler.load_charities_from_file("data/test_urls.csv")

    crawler.get_charity_data()
    crawler.write_charity_data_to_file()


if __name__ == "__main__":
    main()
