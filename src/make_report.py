import get_urls
import urls_to_data
import pandas as pd

def main():
  sourceURL = "https://briinstitute.com/mw/compare.php"
  baseURL = "https://briinstitute.com/mw/"

  # Only grab urls with "ein" in the title (desired url format: "ministry.php?ein=########")
  urlContains = "ein"

if __name__ == "__main__":
  main()