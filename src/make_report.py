import get_urls
import urls_to_data
import pandas as pd

def main():
  sourceURL = "https://briinstitute.com/mw/compare.php"
  baseURL = "https://briinstitute.com/mw/"

  # Only grab urls with "ein" in the title (desired url format: "ministry.php?ein=########")
  urlContains = "ein"
  myURLS = get_urls.get_urls(sourceURL, baseURL, urlContains)

  print("length of url set: " + str(len(myURLS)))
  df = urls_to_data.url_to_table(myURLS[0])
  i = 1
  for url in myURLS[1:5]:
    i = i + 1
    print(str(i))
    df = pd.concat([df, urls_to_data.url_to_table(url)])

  with pd.ExcelWriter("data/test-excel.xlsx") as writer: # pylint: disable=abstract-class-instantiated
    df.to_excel(writer, sheet_name="Sheet1")

  print("number of urls: " + str(len(myURLS)))
  return

if __name__ == "__main__":
  main()