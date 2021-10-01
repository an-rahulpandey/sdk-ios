require 'readersdk2/parser'

describe ReaderSDK2::Parser do
    describe ReaderSDK2::Parser::Framework do
        it 'Loads the content from the json config' do
            framework = ReaderSDK2::Parser.new.frameworks[0]

            expect(framework.name).not_to be_nil
            expect(framework.summary).not_to be_nil
        end

        describe '#source' do
          context '#closed_source' do
            it 'generates a source from the specific framework provided'  do
                parser = ReaderSDK2::Parser.new
                framework = parser.frameworks[0]
                source = framework.source(parser)
                expect(source).to eq({http:"https://reader-sdk-2.s3-us-west-2.amazonaws.com/readersdk2/2.0.0-alpha8/ReaderSDK2_d2f8c954b72.zip"})
            end
          end
          context '#closed_source' do
            it 'generates a source from the specific framework provided'  do
                parser = ReaderSDK2::Parser.new
                framework = parser.frameworks[1]
                source = framework.source(parser)
                expect(source).to eq({http:"https://reader-sdk-2.s3-us-west-2.amazonaws.com/readersdk2/2.0.0-alpha8/MockReaderUI_d2f8c954b72.zip"})
            end
          end
          context '#open_source' do
            it 'generates a source from the specific framework provided'  do
                parser = ReaderSDK2::Parser.new
                framework = parser.frameworks[2]
                has_dependencies = framework.has_dependencies
                expect(has_dependencies).to eq(true)
            end

            it 'generates a dependency from the specific framework provided'  do
                parser = ReaderSDK2::Parser.new
                framework = parser.frameworks[2]
                source = framework.source(parser)
                expect(source).to eq({:git=>"https://github.com/Square-Beta-Testers/reader-sdk-2-ios", :tag=>"2.0.0-alpha8"})
            end
          end
        end

        describe '#private_header_files' do
            it 'generates private_header_files from the specific framework provided'  do
                parser = ReaderSDK2::Parser.new
                framework = parser.frameworks[0]
                source = framework.private_header_files
                expect(source).to eq('**/*.{h}')
            end
        end

        describe '#vendored_frameworks' do
            it 'generates vendored_frameworks from the specific framework provided'  do
                parser = ReaderSDK2::Parser.new
                framework = parser.frameworks[0]
                source = framework.vendored_frameworks
                expect(source).to eq('ReaderSDK2.xcframework')
            end
        end
    end

    describe ReaderSDK2::Parser::App do
    end

    describe ReaderSDK2::Parser::Constants do
        it 'Loads the content from the json config' do
            readersdk_constants = ReaderSDK2::Parser.new.constants

            expect(readersdk_constants.version).not_to be_nil
            expect(readersdk_constants.license).not_to be_nil
            expect(readersdk_constants.homepage).not_to be_nil
            expect(readersdk_constants.authors).not_to be_nil
            expect(readersdk_constants.deployment_target).not_to be_nil
            expect(readersdk_constants.source_root).not_to be_nil
            expect(readersdk_constants.commit_sha).not_to be_nil
        end
    end
end
