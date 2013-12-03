require 'models/blueprints/control'

describe "RockAUV::Control.constant" do
    it "allows to define a cross-domain constant producer" do
        domain = RockAUV::Control.output_domain do
            AlignedPos(:pitch,:roll) | AlignedVel(:x,:yaw)
        end
        constant_producer = RockAUV::Control.constant(domain)
    end
end

