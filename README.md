# Data ScrapeX API

## Overview
Data ScrapeX is a Ruby on Rails application that provides an API to scrape publicly listed companies from Y Combinator. The scraper can retrieve a specified number of companies with various filters and outputs the data in CSV format.

## Features
- Scrape company details from Y Combinator.
- Filter companies based on batch, industry, region, tag, company size, and boolean filters.
- Export scraped data to a CSV file.

## Requirements
- Ruby 3.x
- Rails 6.x or 7.x
- PostgreSQL or SQLite
- Chrome browser
- ChromeDriver
- Selenium WebDriver gem
- Nokogiri gem
- HTTParty gem

## Setup

### 1. Clone the Repository
```bash
git clone https://github.com/shoebimran/DataScrapeX.git
cd DataScrapeX/
```

### 2. Install Dependencies
```bash
bundle install
```

### 3. Install ChromeDriver

- **MacOS:**
  ```bash
  brew install chromedriver
  ```

- **Ubuntu:**
  ```bash
  sudo apt-get install -y chromedriver
  ```

### 4. Running the Server
```bash
rails server
```

## API Endpoint
### Scrape Companies
- **Endpoint:** `POST /api/v1/companies`
- **Description:** Scrapes Y Combinator companies and returns the data in CSV format.
- **Parameters:**
  - `n` (Integer): Number of companies to scrape.
  - `filters` (JSON object): Various filters for scraping.

#### Example Request
```bash
curl -X POST http://localhost:3000/api/v1/companies \
  -H "Content-Type: application/json" \
  -d '{
    "n": 10,
    "filters": {
      "batch": "W22",
      "industry": "Software"
    }
  }'
```

## Code Structure

### DataScrapeService
The `DataScrapeService` class is responsible for scraping the Y Combinator website. It uses Selenium WebDriver to navigate pages and Nokogiri to parse the HTML.

### API Controller
The `Api::V1::CompaniesController` handles the API requests. It initializes the scraper service, processes the request parameters, and sends the CSV file as a response.

### Routes
The API endpoint is defined in `config/routes.rb` under the `api/v1` namespace.

## Notes
- Ensure that the Chrome browser and ChromeDriver are installed and compatible with each other.
- Adjust the sleep time in the `DataScrapeService` if the page loading time varies.

# DataScrapeX
