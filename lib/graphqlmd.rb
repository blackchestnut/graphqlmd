require 'graphqlmd/consts'
require 'graphqlmd/version'
require 'json'
require 'net/http'
require 'uri'

class Graphqlmd::Graphqlmd
  include ::Graphqlmd

  def initialize options
    @url = options[:url]
    @is_hide_client_mutation_id = options[:is_hide_client_mutation_id]
    @is_hide_deprecated = options[:is_hide_deprecated]
    @is_hide_scalar = options[:is_hide_scalar]
    @is_allow_links = options[:is_allow_links]
    @is_vuepress = options[:is_vuepress]
    @ignored_queries = options[:ignored_queries]
    @ignored_mutations = options[:ignored_mutations]
    @ignored_objects = options[:ignored_objects]
  end

  def call
    response = fetch_schema
    data = JSON.parse(response.body).dig 'data', 'schema'
    puts_queries data['queries']
    puts_mutations data['mutations']
    puts_objects data['types']
  end

private

  def puts_queries data
    print_header 'Queries'
    queries = data['fields']
      .reject { |v| @ignored_queries.include? v['name'] }
      .sort_by { |v| v['name'] }

    queries.each do |v|
      puts "\n### #{v['name']}\n"
      print_deprecation v
      puts "Return Type | Description\n"
      puts "-|-\n"
      puts "#{type_as_string v['type']} | #{print_description(v['description'])}\n"
      print_args v['args']
    end
  end

  def puts_mutations data
    print_header 'Mutations'
    mutations = data['fields']
      .reject { |v| @ignored_mutations.include? v['name'] }
      .sort_by { |v| v['name'] }

    mutations = mutations.reject { |v| v['isDeprecated'] } if @is_hide_deprecated

    mutations.each do |v|
      puts "\n### #{v['name']}\n"
      print_deprecation v
      puts "Return Type | Description\n"
      puts "-|-\n"
      puts "#{type_as_string v['type']} | #{print_description(v['description'])}\n"
      print_args v['args']
    end
  end

  def puts_objects data
    print_header 'Objects'
    objects = data
      .reject { |v| IGNORED_OBJECT_NAMES.include? v['name'] }
      .reject { |v| @ignored_objects.include? v['name'] }
      .sort_by { |v| v['name'] }
    objects = objects.reject { |v| v['kind'] == SCALAR } if @is_hide_scalar

    objects.each do |v|
      puts "\n### #{v['name']}\n"
      puts "#{print_description v['description']}\n" unless v['description'].nil?
      print_fields v['fields'] || v['inputFields']
      print_enum_values v['enumValues']
    end

    nil
  end

  def print_header value
    puts "## #{value}\n"
  end

  def print_fields fields
    return if fields.nil?
    return if fields.empty?

    puts "\n**Fields**\n"
    puts "Name | Type | Description\n"
    puts "-|-|-\n"
    fields.each do |v|
      next if v['name'] == CLIENT_MUTATION_ID && @is_hide_client_mutation_id

      puts "#{v['name']} | #{type_as_string(v['type'])} | #{print_description(v['description'])}\n"
    end
  end

  # TODO: Print deprecationReason for Enum Values
  def print_enum_values values
    return if values.nil?
    return if values.empty?

    puts "\n**Values**\n"
    puts "Name | Description\n"
    puts "-|-\n"
    values.each do |v|
      puts "#{v['name']} | #{print_description(v['description'])}\n"
    end
  end

  def print_args args
    return if args.nil?
    return if args.empty?

    puts "#### Arguments\n"
    puts "Name | Type | Description\n"
    puts "-|-|-|-\n"
    args.each do |v|
      puts "#{v['name']} | #{type_as_string(v['type'])} | #{print_description(v['description'])}\n"
    end
  end

  def print_description value
    return if value.nil? || value.empty?

    "_#{value}_"
  end

  def print_deprecation data
    return unless data['isDeprecated']

    if @is_vuepress
      puts "::: warning DEPRECATED\n"
      puts "#{data['deprecationReason']}\n"
      puts ":::\n\n"
    else
      puts "> **DEPRECATED**\n"
      puts ">\n"
      puts "> #{data['deprecationReason']}\n\n"
    end
  end

  def type_as_string type
    is_required = type['kind'] == NON_NULL
    is_list = type['kind'] == LIST

    if type['name']
      "#{name_as_link(type)}#{required_postfix(is_required)}"
    elsif is_list
      "[#{type_as_string(type['ofType'])}#{required_postfix(is_required)}]"
    else
      "#{type_as_string(type['ofType'])}#{required_postfix(is_required)}"
    end
  end

  def required_postfix is_required
    is_required ? '!' : ''
  end

  def name_as_link type
    return type['name'] unless @is_allow_links
    return type['name'] if type['kind'] == SCALAR

    "[#{type['name']}](##{type['name'].downcase})"
  end

  def fetch_schema
    uri = URI.parse @url

    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Post.new uri.request_uri, headers
      request.body = body
      http.request request
    end
  end

  def headers
    {
      'Content-Type' => 'application/json'
    }
  end

  def body
    { query: SCHEMA_QUERY, variables: nil }.to_json
  end
end
