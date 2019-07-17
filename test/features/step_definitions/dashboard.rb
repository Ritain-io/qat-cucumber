When /^I check the errors in the dashboard for this test:$/ do |table|

  table.headers.each do |header|
    table.map_column! header do |value|
      if value == 'nil'
        nil
      else

        if ['tags', 'outline_example'].include? header and value
          value = value.split ','
        end

        value = value.to_i if header == 'outline_number'

        value
      end
    end
  end

  lines = table.raw.size - 1

  url = "http://localhost:9200/errors-qat-#{Time.now.utc.strftime('%Y.%m.%d')}/_search"

  body = <<-JSON
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "facility": "QAT Error Dashboard"
          }
        }
      ],
      "filter": [
        {
          "range": {
            "@timestamp": {
              "gte": "#{@test_start_ts}",
              "lte": "#{Time.now.utc.iso8601(3)}"
            }
          }
        }
      ]
    }
  }
}
  JSON
  obj=[]

  puts body

  opts = { body: body, headers: {'Content-Type' => 'application/json'} }

  if ENV['ES_USER'] and ENV['ES_PASSWD']
    opts[:basic_auth] = { username: ENV['ES_USER'], password: ENV['ES_PASSWD'] }
  end

  Retriable.retriable on: Minitest::Assertion, tries: 30, base_interval: 0.5, multiplier: 1.0, rand_factor: 0.0 do
    result = HTTParty.get(url, opts).body
    Log4r::Logger.log_internal { "Result: #{result}" }

    result = JSON.parse result

    temp = result['hits']['hits'] rescue []
    obj = temp.map { |hit| hit['_source'] }.sort { |a, b| Time.parse(a['@timestamp']) <=> Time.parse(b['@timestamp']) } rescue temp
    assert obj.size == lines, "No Log was found with timestamp [#{@test_start_ts}, #{Time.now.iso8601(3)}]\nResult :#{result}"
  end


  table.hashes.each_with_index do |line, i|
    puts obj[i]
    line.each do |key, value|
      puts "Key '#{key}' - Expected '#{value}', Actual '#{obj[i][key]}'"
      if value
        assert_equal value, obj[i][key]
      else
        refute obj[i].has_key? key
      end
    end
  end
end