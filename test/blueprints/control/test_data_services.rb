require 'models/blueprints/control'

describe RockAUV::Control do
    it "allows to combine control domains into a new data service model" do
        domain = RockAUV::Control.input_domain do
            AlignedVel(:x) | WorldPos(:pitch,:roll) | WorldPos(:z)
        end
    end
end

