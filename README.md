# StocksApp 📈
StocksApp is an iOS application that allows users to search, track, and analyze stock prices in real time. 
The app integrates Finnhub and Alpha Vantage APIs to fetch financial data and displays stock trends using DGCharts. 
It uses 4 main screens:
  1. List of stocks with search bar
  2. Screen of Stock Details
  3. Screen of Popular Requests
  4. Screen for search and filter stocks
     
## Technologies used
  - Swift
  - UIKit
  - MVP
  - CoreData
  - GCD
  - URLSession
  - Cocoapods
  - GDCharts
  - JSON Parsing
     
## Screen 1 - List of stocks with search bar
  - Presents a list of stocks retrieved via API calls.
  - Each contact is shown in a custom cell with:
      - Name
      - Ticker
      - Image
      - Current Price
      - Price Change Indicator (with percentage)
      - Favourite Button
  - Loads stocks from CoreData.
  - Presents a list of favourite stocks.
  - Displays a search bar where users can look up stocks by name or ticker.
  - Allows users to tap a stock to view more details.
    


## Screen 2 - Screen of Stock Details
  - Provides detailed stock information:
      - Current Price
      - Chart of trends
      - Buy Button
  - Displays historical stock trends using DGCharts (Cocoapods).
  - Allows users to switch between timeframes:
      - 1 Day
      - 1 Week
      - 1 Month 
      - 6 Months
      - 1 Year
      - 5 Years (All)
  - Implements custom data markers for precise price tracking.





## Screen 3 - Screen of Popular Requests
  - Displays popular & recently searched stocks.
  - Shows the stock, which was tapped.
  - Appears when search bar is tapped, but text is not provided.
  - Search bar has 2 buttons for search and remove the text.


## Screen 4 - Screen for search and filter stocks
  - Displays stocks by entered name or ticker.
  - Appears when search bar is tapped, and text is provided.
  - Search bar has 2 buttons for search and remove the text.






