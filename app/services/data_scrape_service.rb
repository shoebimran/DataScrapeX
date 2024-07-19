# frozen_string_literal: true

require 'nokogiri'
require 'httparty'
require 'csv'
require 'selenium-webdriver'

class DataScrapeService
  BASE_URL = 'https://www.ycombinator.com/companies'
  SLEEP_TIME = 3

  def initialize(n:, filters:)
    @n = n
    @filters = filters
  end

  def scrape
    companies = []
    page = 1
    driver = Selenium::WebDriver.for :chrome

    while companies.size < @n
      driver.navigate.to build_url(page)
      sleep SLEEP_TIME # Allow time for the page to load

      company_elements = parse_company_elements(driver.page_source)
      company_elements.each do |element|
        break if companies.size >= @n
        companies << extract_company_info(element)
      end

      break if companies.size >= @n
      page += 1
    end

    driver.quit
    companies
  end

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << %w[Company Name Location Short Description YC Batch Website Founder Names LinkedIn URLs]

      scrape.each do |company|
        csv << company.values
      end
    end
  end

  private

  def build_url(page)
    "#{BASE_URL}?page=#{page}&#{filters_query}"
  end

  def parse_company_elements(page_source)
    document = Nokogiri::HTML(page_source)
    document.css('a._company_86jzd_338')
  end

  def extract_company_info(element)
    company_name = element.css('span._coName_86jzd_453').text.strip
    company_location = element.css('span._coLocation_86jzd_469').text.strip
    short_description = element.css('span._coDescription_86jzd_478').text.strip
    yc_batch = element.css('span._pill_86jzd_33').text.strip

    company_url = "https://www.ycombinator.com#{element['href']}"
    company_details = fetch_company_details(company_url)

    {
      company_name:,
      company_location:,
      short_description:,
      yc_batch:,
      website: company_details[:website],
      founder_names: company_details[:founder_names].join(', '),
      linkedin_urls: company_details[:linkedin_urls]
    }
  end

  def fetch_company_details(url)
    response = HTTParty.get(url)
    document = Nokogiri::HTML(response.body)

    website = document.css('a[target="_blank"]').find { |link| link['href'].include?('http') }&.[]('href') || ''
    founder_names = document.css('div.space-y-5 div.flex-grow h3.text-lg.font-bold').map(&:text).map(&:strip)
    linkedin_urls = document.css('a.inline-block.w-5.h-5.bg-contain.bg-image-linkedin').find { |link| link['href'].include?('linkedin.com/company') }&.[]('href') || ''

    { website:, founder_names:, linkedin_urls: }
  end

  def filters_query
    @filters.map { |key, value| "#{key}=#{value}" }.join('&')
  end
end
