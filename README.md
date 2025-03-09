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
    
<p align="middle">
<img src="https://github.com/user-attachments/assets/bdae28b2-963a-41e9-8b26-06b7fe808bfb" width="191.17" height="400" />
<img src="https://github.com/user-attachments/assets/ba097390-1349-435c-a4e4-6734a5150597" width="191.17" height="400" />
<img src="https://github.com/user-attachments/assets/50e1fa5d-c038-4cf2-81a9-0f92ecb35341" width="191.17" height="400" />

<!-- ![Simulator Screenshot - iPhone 16 Pro - 2025-03-07 at 03 54 03](https://github.com/user-attachments/assets/bdae28b2-963a-41e9-8b26-06b7fe808bfb) -->
<!-- ![Simulator Screenshot - iPhone 16 Pro - 2025-03-07 at 03 55 49](https://github.com/user-attachments/assets/ba097390-1349-435c-a4e4-6734a5150597) -->
<!-- ![Simulator Screenshot - iPhone 16 Pro - 2025-03-07 at 03 55 52](https://github.com/user-attachments/assets/50e1fa5d-c038-4cf2-81a9-0f92ecb35341) -->


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

    
<p align="middle">
<img src="https://github.com/user-attachments/assets/b5a10fba-5f8d-4d8f-bc88-e726a2a3e011" width="191.17" height="400" />
<img src="https://github.com/user-attachments/assets/16c1c333-94ef-4fe2-80d1-ebb266ed2a7d" width="191.17" height="400" />
<img src="https://github.com/user-attachments/assets/03725e1c-317b-4439-93e4-857939596cb0" width="191.17" height="400" />

<!-- 
![Simulator Screenshot - iPhone 16 Pro Max - 2025-03-07 at 04 09 06](https://github.com/user-attachments/assets/b5a10fba-5f8d-4d8f-bc88-e726a2a3e011)
![Simulator_Screenshot_iPhone_16_Pro_Max_2025_03_05_at_15_11_43](https://github.com/user-attachments/assets/16c1c333-94ef-4fe2-80d1-ebb266ed2a7d)
![Simulator Screenshot - iPhone 16 Pro Max - 2025-03-07 at 04 10 48](https://github.com/user-attachments/assets/03725e1c-317b-4439-93e4-857939596cb0)
-->



## Screen 3 - Screen of Popular Requests
  - Displays popular & recently searched stocks.
  - Shows the stock, which was tapped.
  - Appears when search bar is tapped, but text is not provided.
  - Search bar has 2 buttons for search and remove the text.
    
<p align="middle">
<img src="https://github.com/user-attachments/assets/91b6ef85-7e7e-4b4b-86f7-2006ee9abed9" width="191.17" height="400" />
<img src="https://github.com/user-attachments/assets/e7d4f550-fc0e-43a6-8e81-45edb624575c" width="191.17" height="400" />
<img src="https://github.com/user-attachments/assets/2013e805-702f-4e94-bbab-75fa4d1abf9c" width="191.17" height="400" />
<img src="https://github.com/user-attachments/assets/43bd82ea-2b6e-4f32-b02a-6b385870274a" width="191.17" height="400" />

<!-- 

![Simulator Screenshot - iPhone 16 Pro Max - 2025-03-07 at 04 12 45](https://github.com/user-attachments/assets/91b6ef85-7e7e-4b4b-86f7-2006ee9abed9)
![Simulator Screenshot - iPhone 16 Pro Max - 2025-03-07 at 04 13 25](https://github.com/user-attachments/assets/e7d4f550-fc0e-43a6-8e81-45edb624575c)
![Simulator Screenshot - iPhone 16 Pro Max - 2025-03-07 at 04 13 31](https://github.com/user-attachments/assets/2013e805-702f-4e94-bbab-75fa4d1abf9c)
![Simulator Screenshot - iPhone 16 Pro Max - 2025-03-07 at 04 13 33](https://github.com/user-attachments/assets/43bd82ea-2b6e-4f32-b02a-6b385870274a)
-->

## Screen 4 - Screen for search and filter stocks
  - Displays stocks by entered name or ticker.
  - Appears when search bar is tapped, and text is provided.
  - Search bar has 2 buttons for search and remove the text.






