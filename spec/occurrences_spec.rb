require File.join(File.dirname(__FILE__), "helpers")
require "sensu/extensions/occurrences"

describe "Sensu::Extension::Occurrences" do
  include Helpers

  before do
    @extension = Sensu::Extension::Occurrences.new
  end

  it "can filter events using occurrences" do
    async_wrapper do
      event = event_template
      @extension.safe_run(event) do |output, status|
        expect(status).to eq(1)
        event[:check][:occurrences] = 3
        @extension.safe_run(event) do |output, status|
          expect(status).to eq(0)
          event[:occurrences] = 3
          @extension.safe_run(event) do |output, status|
            expect(status).to eq(1)
            async_done
          end
        end
      end
    end
  end

  it "can filter events using occurrences with a refresh" do
    async_wrapper do
      event = event_template
      event[:check][:interval] = 2
      @extension.safe_run(event) do |output, status|
        expect(status).to eq(1)
        event[:check][:occurrences] = 3
        @extension.safe_run(event) do |output, status|
          expect(status).to eq(0)
          event[:occurrences] = 3
          @extension.safe_run(event) do |output, status|
            expect(status).to eq(1)
            event[:occurrences] = 9
            @extension.safe_run(event) do |output, status|
              expect(status).to eq(0)
              event[:check][:refresh] = 10
              @extension.safe_run(event) do |output, status|
                expect(status).to eq(0)
                event[:check][:refresh] = 12
                @extension.safe_run(event) do |output, status|
                  expect(status).to eq(1)
                  async_done
                end
              end
            end
          end
        end
      end
    end
  end

  it "will not filter events using occurrences with resolve action" do
    async_wrapper do
      event = event_template
      event[:check][:occurrences] = 2
      event[:occurrences] = 5
      @extension.safe_run(event) do |output, status|
        expect(status).to eq(0)
        event[:action] = :resolve
        @extension.safe_run(event) do |output, status|
          expect(status).to eq(1)
          async_done
        end
      end
    end
  end
end
