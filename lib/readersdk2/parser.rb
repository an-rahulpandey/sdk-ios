require 'json'

module ReaderSDK2
  class Parser
    attr_reader :constants, :frameworks, :apps

    class Constants
      attr_reader :version, :license, :homepage, :authors, :deployment_target, :source_root, :commit_sha

      def initialize(json)
        @version = json.version
        @homepage = json.homepage
        @authors = json.authors
        @deployment_target = json.deployment_target
        @source_root = json.source_root
        @commit_sha = json.commit_sha

        self.license = json.license.type
      end

      def license=(license_type)
        @license = {
          'type': license_type,
          'text': File.read('./Config/license.txt')
        }
      end
    end

    class Framework
      attr_reader :name, :summary, :open_source, :depedencies

      alias  :open_source? :open_source

      def initialize(json)
        @name = json.name
        @summary = json.summary
        @open_source = json.open_source || false
        @depedencies = json.depedencies || []
      end

      def source(parser)
        return { git: parser.constants.homepage, tag: parser.constants.version } if open_source?

        { http: File.join(parser.constants.source_root, parser.constants.version, "#{name}_#{parser.constants.commit_sha}.zip") }
      end

      def vendored_frameworks
        return nil if open_source?

        File.join("#{name}.xcframework")
      end

      def private_header_files
        return nil if open_source?

        File.join('**', '*.{h}')
      end

      def source_files
        return File.join('**', '*.{swift}')  unless open_source?

        File.join('Frameworks', name, 'Sources', '**', '*.swift')
      end

      def resource_files
        return nil unless open_source?

        File.join('Frameworks', name, 'Resources', "**", "*")
      end

      def resource_bundle_name
        return nil unless open_source?
        return "#{name}Resources"
      end

      def has_dependencies
        return !depedencies.empty?
      end
    end

    class App
      attr_reader :name, :summary, :depedencies

      def initialize(json)
        @name = json.name
        @summary = json.summary
        @depedencies = json.depedencies
      end

      def source_files
        File.join('Apps', name, 'Sources', '**', '*.swift')
      end

      def main_source_files
        File.join('Apps', name, 'Main', '**', '*.swift')
      end

      def resource_files
        File.join('Apps', name, 'Resources', "**", "*")
      end

      def resource_bundle_name
        return "#{name}Resources"
      end

      def info_plist_path
        return File.join('${PODS_TARGET_SRCROOT}', 'Apps', name, 'Support', 'Info.plist')
      end
    end

    def initialize
      @constants = Constants.new(json.constants)
      @frameworks = json.frameworks.map { |framework_json| Framework.new(framework_json) }
      @apps = json.apps.map { |app_json| App.new(app_json) }
    end

    def source_files(framework)
      return nil unless framework.open_source?

      File.join('Frameworks', framework.name, 'Sources', '**', '*.swift')
    end

    private

    def json
      @json ||= JSON.parse(File.read('./Config/config.json'), object_class: OpenStruct)
    end
  end
end
