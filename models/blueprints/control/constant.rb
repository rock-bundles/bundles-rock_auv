module RockAUV
    module Control
        def self.constant(domain_srv = nil, &block)
            domain_srv ||= self.output_domain(&block)

            Syskit::TaskContext.new_submodel do
                domain_srv.each_output_port do |port|
                    output_port port.name, port.orogen_model.orocos_type_name
                end
                provides domain_srv, :as => 'cmd'
            end
        end
    end
end

