require 'readersdk2/generator'

describe ReaderSDK2::Generator do
    describe '#render' do
        it 'renders the template' do 
            generator = ReaderSDK2::Generator.new(ReaderSDK2::Parser.new)
            generator.save
        end
    end
end