require 'models/blueprints/control'
class AuvControl::Base
    Hash['in' => ::RockAUV::Control::INPUTS, 'out' => ::RockAUV::Control::OUTPUTS].each do |prefix, srv_sets|
        srv_sets.each do |reference, quantities|
            quantities.each do |quantity, srv|
                dynamic_service srv, :as => "#{prefix}_#{reference}_#{quantity}" do
                    provides srv, :as => name, "cmd_in_#{reference}_#{quantity}" => "cmd_in_#{name}"
                end
            end
        end
    end
end

class AuvControl::ConstantCommand
    argument :cmd, :default => nil

    def configure
        super
        if cmd
            orocos_task.cmd = cmd
        end
    end
end
