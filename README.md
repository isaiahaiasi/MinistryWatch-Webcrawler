# README

## Purpose
Gather public data on charities from MinistryWatch website.

## Overview
requirements.txt included, but the versions listed might not be compatible with versions of python older than 3.9.1
## Scripts
### get_urls.py
Running this script looks at the table on https://briinstitute.com/mw/compare.php and exports the link url, the name of the charity, and the charity's sector to a .csv file. These urls are then referenced to find the detailed tables for each charity. Charity name and sector are included here because on this page they're contained in \<td\> tags, whereas they are harder to pull on the individual charity page.
Running this script from the command line does not take any arguments.

### urls_to_data.py
Running this script tries to find the stored .csv generated by get_urls.py, makes a dataframe for each charity link, then concatenates those dataframes and generates an .xlsx sheet from them.

### make_report.py
Currently a stub script. This should run get_urls.py and urls_to_data.py sequentially, to make generating the full report from scratch easier.