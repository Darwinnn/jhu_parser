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
            ret = Hash(Symbol, Hash(Symbol, Int32)).new do |hash, key|
                hash[key] = {:total => 0, :diff => 0}
            end

            data.each do |_, value|
                %i(recovered confirmed dead).each do |key|
                    ret[key][:total] += value[key][:total]
                    ret[key][:diff]  += value[key][:diff]
                end
            end
            ret
        end

        private def data
            # {"country": {:confirmed => {:total => 0, :diff => 0 } } }
            ret = Hash(String, Hash(Symbol, Hash(Symbol, Int32))).new do |hash, key|
                hash[key] = {
                    :confirmed => {:total => 0, :diff => 0},
                    :recovered => {:total => 0, :diff => 0},
                    :dead      => {:total => 0, :diff => 0}
                }
            end

            HTTP::Client.get(JHU_CONFIRMED_URL) do |resp|
                parse_csv(resp.body_io).each do |k,v|
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
            ret = Hash(String, Hash(Symbol, Int32)).new({} of Symbol => Int32)
            while csv.next
                if ret[csv["Country/Region"]]?.nil?
                    ret[csv["Country/Region"]] = {
                        :total => csv.row.to_a.[-1].to_i,
                        :diff => (csv.row.to_a.[-1].to_i - csv.row.to_a.[-2].to_i)
                    }
                else 
                    ret[csv["Country/Region"]][:total] += csv.row.to_a.[-1].to_i
                    ret[csv["Country/Region"]][:diff]  += (csv.row.to_a.[-1].to_i - csv.row.to_a.[-2].to_i)
                end
            end
            ret
        end
    end
end



