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
  - Shows loading page with activity indicator
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
  <p align="middle">
  <img src="https://github.com/user-attachments/assets/bf1bff7b-8914-4b94-84fe-58bc7b8fc40a" width="191.17" height="400" />
  <img src="https://github.com/user-attachments/assets/eee513ca-9fa0-4e7d-8e4b-ffaf856128f2" width="191.17" height="400" />
  <img src="https://github.com/user-attachments/assets/3706e05a-1abd-4c81-b8b9-fe30930c20e3" width="191.17" height="400" />



## Screen 2 - Screen of Stock Details
  - Shows loading page with activity indicator
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
  - Can add stock to favourites.

  <p align="middle">
  <img src="https://github.com/user-attachments/assets/a4fdba4b-eb8d-412a-a635-f5e5814b78c2" width="191.17" height="400" />
  <img src="https://github.com/user-attachments/assets/f54e699a-6a46-448d-9ae7-577d9785544b" width="191.17" height="400" />
  <img src="https://github.com/user-attachments/assets/acc5acb7-4e4b-463d-9bf2-f265314a6150" width="191.17" height="400" />
  <img src="https://github.com/user-attachments/assets/aff7ae57-5bc7-496d-9d96-e0bcd88bd4ca" width="191.17" height="400" />
  <img src="https://github.com/user-attachments/assets/9edf1718-a666-4aac-b97a-e62cb4c6c1ec" width="191.17" height="400" />
    



## Screen 3 - Screen of Popular Requests
  - Appears when search bar is tapped, but text is not provided.
  - Displays popular & recently searched stocks by names.
  - Search bar has 2 buttons for search and remove the text.
  - Demonstrates screen of sctock details when user tapped the one stock.

  <p align="middle">
  <img src="https://github.com/user-attachments/assets/63ef4e92-e06b-469f-a320-94bb361e2906" width="191.17" height="400" />
  <img src="https://github.com/user-attachments/assets/dade0bb4-d5a5-4429-af0f-b9f8635b03ea" width="191.17" height="400" />
  <img src="https://github.com/user-attachments/assets/bdbcfe7a-8893-4037-b88d-3f4bfb278352" width="191.17" height="400" />






## Screen 4 - Screen for search and filter stocks
  - Displays stocks by entered name or ticker.
  - Appears when search bar is tapped, and text is provided.
  - Can add searched stocks to favourites.

  <p align="middle">
  <img src="https://github.com/user-attachments/assets/47336f8b-f0e2-4d5e-b002-a43bfbe8b05d" width="191.17" height="400" />
  <img src="https://github.com/user-attachments/assets/4c4650a8-3c9c-4c99-b4d5-f5dd0fb0aee4" width="191.17" height="400" />
  <img src="https://github.com/user-attachments/assets/199086dc-7d57-4c07-99ae-83448e82ab4b" width="191.17" height="400" />
  <img src="https://github.com/user-attachments/assets/3e94bcc7-cb0c-4920-848e-98ba36948e25" width="191.17" height="400" />
  <img src="https://github.com/user-attachments/assets/6637d79b-be85-489d-a796-5d51eaa1e421" width="191.17" height="400" />




