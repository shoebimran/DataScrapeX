# frozen_string_literal: true

module Api
  module V1
    class CompaniesController < ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        n = params[:n].to_i
        filters = params[:filters].permit!.to_h

        if invalid_params?(n)
          render_invalid_params_error
          return
        end

        generate_and_send_csv(n, filters)
      rescue StandardError => e
        render_internal_server_error(e)
      end

      private

      def invalid_params?(n)
        n <= 0
      end

      def render_invalid_params_error
        render json: { error: 'Invalid value for n' }, status: :bad_request
      end

      def generate_and_send_csv(n, filters)
        scraper_service = DataScrapeService.new(n:, filters:)
        csv_data = scraper_service.to_csv
        send_data csv_data, filename: 'y_combinator_companies.csv', type: 'text/csv'
      end

      def render_internal_server_error(error)
        render json: { error: error.message }, status: :internal_server_error
      end
    end
  end
end
