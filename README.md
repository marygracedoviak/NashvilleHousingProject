# NashvilleHousingProject
## Description
The goal of this project was to take data from an excel spreadsheet to gain insight into the Nashville housing market, so that both consumers and sellers
will be better informed in their buying and selling. 
## Cleaning the Data
The first thing I did was copy all of the data into a temp table, so that I could use that to clean and alter the data. I did this in case the original data
was needed or in case any errors occurred. 

I used the ROW_NUMBER function to remove any duplicates from the data.

I standardized a few different columns, such as the SaleDate and the SoldAsVacant columns, in order to make the data easier to look at and query. 

I used a self join to fill in any NULL values in the PropertyAddress column, then 
I separated all addresses into parts(address, city, state).
Separating the addresses makes the data much easier to query, as I can then filter the data based off city or state. 

I used a simple calculation to create the TotalBaths column, as I thought that would be helpful in querying. 

Finally, I deleted any columns that were no longer needed. 
## Querying the data
The first two queries look at the popularity of different areas or features, namely, cities and bedroom count. 

Using the results from those queries, I looked at the avergage sale price of homes in each century, where the home is in Nashville and has 3 bedrooms. 

Lastly, I looked at the number of sales in each month. 
## To run the program
First you'll need to download the Excel spreadsheet, then import it into your SQL system/database. All queries will be run off of this imported table. 

This Excel document should be the only thing you need to run this program, assuming you have a SQL server and management tool. 
## Conclusions Drawn
In terms of sale price, it seems to move up and down between 1800-2020, as opposed to simply trending upward over the years. My conclusion is that houses from the 1800s are sold at
a higher price as historical pieces as opposed to a livable home. Prices trend upward from 1900s to 2000s and then go back down in the 2010s. I believe this is because
the houses are brand new, so the price takes into account any potential issues that have not yet been discovered. 

As far as number of sales per month, summer is definitely the most popular time for buying. This would be a good time for sellers to list their properties, 
but might not be the best time for consumers to be looking at buying. The 4 least popular months are all in winter, so that would be a great time to look at purchasing property. 
