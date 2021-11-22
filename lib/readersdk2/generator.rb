require 'readersdk2/parser'
require 'erb'

module ReaderSDK2
    class Generator
        attr_reader :parser

        def initialize(parser)
            @parser = parser
        end

        def save
            parser.frameworks.each do |framework|
                FrameworkGenerator.new(framework, parser).save
            end

            parser.apps.each do |framework|
                AppGenerator.new(framework, parser).save
            end
        end

    end

    class FrameworkGenerator
        attr_reader :framework, :parser

        def initialize(framework, parser)
          @framework = framework
          @parser = parser
        end

        def save
            File.open("#{framework.name}.podspec", "w+") do |f|
                f.write(render)
            end
        end

        def render
            ERB.new(template).result(binding)
        end

        private

        def template
            @template ||= File.read('lib/readersdk2/templates/framework.erb')
        end
    end

    class AppGenerator
        attr_reader :app, :parser

        def initialize(app, parser)
          @app = app
          @parser = parser
        end

        def save
            File.open("#{app.name}.podspec", "w+") do |f|
                f.write(render)
            end
        end

        def render
            ERB.new(template).result(binding)
        end

        private

        def template
            @template ||= File.read('lib/readersdk2/templates/app.erb')
        end
    end
end