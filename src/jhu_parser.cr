require "csv"
require "http/client"
module JHU
    class Parser
        JHU_CONFIRMED_URL = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
        JHU_DEAD_URL      = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"
        JHU_RECOVERED_URL = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv"
        
        def get(country : String)
            ret = data
            ret[country] unless ret.nil?
        end

        def all
            data
        end

        def total
            ret = {:confirmed => 0, :recovered => 0, :dead => 0}
            data.each do |country, value|
                ret[:confirmed] += value[:confirmed]
                ret[:recovered] += value[:recovered]
                ret[:dead] += value[:dead]
            end
            ret
        end

        private def data
            ret = Hash(String, Hash(Symbol, Int32)).new

            HTTP::Client.get(JHU_CONFIRMED_URL) do |resp|
                parse_csv(resp.body_io).each do |k,v|
                    ret[k] = {:confirmed => 0, :dead => 0} unless ret[k]?
                    ret[k][:confirmed] = v
                end
            end
            
            HTTP::Client.get(JHU_DEAD_URL) do |resp|
                parse_csv(resp.body_io).each do |k,v|
                    ret[k][:dead] = v
                end
            end

            HTTP::Client.get(JHU_RECOVERED_URL) do |resp|
                parse_csv(resp.body_io).each do |k,v|
                    ret[k][:recovered] = v
                end
            end

            ret
        end

        private def parse_csv(body : IO)
            csv = CSV.new(body, headers: true)
            ret = Hash(String, Int32).new(0)
            while csv.next 
                ret[csv["Country/Region"]] += csv.row.to_a.last.to_i
            end
            ret
        end
    end
end



