require 'models/blueprints/control'

describe "RockAUV::Control.netgen" do
    describe "#producer_domains" do
        attr_reader :producer
        before do
            domain = RockAUV::Control.output_domain do
                AlignedPos(:pitch,:roll) | AlignedVel(:x,:yaw)
            end
            @producer = RockAUV::Control.constant(domain)
        end

        it "splits the producer across its domains" do
            result = RockAUV::Control.producer_domains('test', producer)
            assert_equal [[:aligned,:pos],[:aligned,:vel]].to_set,
                result.map(&:domain).to_set
        end
        it "finds the exact data service for the given domain" do
            result = RockAUV::Control.producer_domains('test', producer)
            aligned_pos = result.find { |p| p.domain == [:aligned,:pos] }
            assert_equal producer.cmd_srv.as(RockAUV::Control::OutputAlignedPosSrv),
                aligned_pos.srv
        end
    end
end

