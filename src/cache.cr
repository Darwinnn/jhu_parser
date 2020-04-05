require "./jhu_parser"

class Cache
    getter data

    def initialize
        @data = Hash(String, Hash(Symbol, Hash(Symbol, Int32))).new
        spawn do
            while true
                p "#{Time.local.to_s} - Parsing JHU data"
                jhu = JHU::Parser.new
                @data = jhu.all
                @data["total"] = jhu.total
                p "#{Time.local.to_s} - Done parsing JHU data"
                sleep 60
            end
        end
    end
end