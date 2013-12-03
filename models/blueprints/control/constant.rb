module RockAUV
    module Control
        class Constant < Syskit::Composition
        end

        def self.constant(domain_srv = nil, &block)
            domain_srv ||= self.output_domain(&block)
            generator = Constant.new_submodel do
                domain_srv.domain.each do |reference, quantity, _|
                    child = add AuvControl::ConstantCommand, :as => "#{reference}_#{quantity}"

                    # Export the constant generator output. Use a name that
                    # match the port name fo the Control data services
                    export child.cmd_out_port, :as => "cmd_out_#{reference}_#{quantity}"
                end
                provides domain_srv, :as => 'cmd'
            end

            generator.cmd_srv
        end
    end
end

