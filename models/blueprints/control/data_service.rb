module RockAUV
    module Control
        def self.WorldPos(*parameters)
            Domain.new(:world, :pos, Axis.new(*parameters))
        end
        def self.WorldVel(*parameters)
            Domain.new(:world, :vel, Axis.new(*parameters))
        end
        def self.AlignedPos(*parameters)
            Domain.new(:aligned, :pos, Axis.new(*parameters))
        end
        def self.AlignedVel(*parameters)
            Domain.new(:aligned, :vel, Axis.new(*parameters))
        end
        def self.AlignedEffort(*parameters)
            Domain.new(:aligned, :effort, Axis.new(*parameters))
        end
        def self.BodyEffort(*parameters)
            Domain.new(:body, :effort, Axis.new(*parameters))
        end

        # Representation as a data service of a single-axis control domain
        class DomainSrvModel < Syskit::Models::DataServiceModel
            # @return [Domain]
            attr_accessor :domain

            def initialize
                @domain = Domain.new
                super
            end

            def to_s
                "DomainSrv(#{domain})"
            end
        end
        DomainSrv  = DomainSrvModel.new
        DomainSrv.provides Syskit::DataService
        InputDomainSrv = DomainSrv.new_submodel
        OutputDomainSrv = DomainSrv.new_submodel

        WorldPosSrv       = DomainSrv.new_submodel
        InputWorldPosSrv  = WorldPosSrv.new_submodel do
            provides InputDomainSrv
            input_port 'cmd_in_world_pos', '/base/LinearAngular6DCommand'
        end
        OutputWorldPosSrv = WorldPosSrv.new_submodel do
            provides OutputDomainSrv
            output_port 'cmd_out_world_pos', '/base/LinearAngular6DCommand'
        end

        WorldVelSrv      = DomainSrv.new_submodel
        InputWorldVelSrv  = WorldVelSrv.new_submodel do
            provides InputDomainSrv
            input_port 'cmd_in_world_vel', '/base/LinearAngular6DCommand'
        end
        OutputWorldVelSrv = WorldVelSrv.new_submodel do
            provides OutputDomainSrv
            output_port 'cmd_out_world_vel', '/base/LinearAngular6DCommand'
        end

        AlignedPosSrv    = DomainSrv.new_submodel
        InputAlignedPosSrv  = AlignedPosSrv.new_submodel do
            provides InputDomainSrv
            input_port 'cmd_in_aligned_pos', '/base/LinearAngular6DCommand'
        end
        OutputAlignedPosSrv = AlignedPosSrv.new_submodel do
            provides OutputDomainSrv
            output_port 'cmd_out_aligned_pos', '/base/LinearAngular6DCommand'
        end

        AlignedVelSrv    = DomainSrv.new_submodel
        InputAlignedVelSrv  = AlignedVelSrv.new_submodel do
            provides InputDomainSrv
            input_port 'cmd_in_aligned_vel', '/base/LinearAngular6DCommand'
        end
        OutputAlignedVelSrv = AlignedVelSrv.new_submodel do
            provides OutputDomainSrv
            output_port 'cmd_out_aligned_vel', '/base/LinearAngular6DCommand'
        end

        AlignedEffortSrv = DomainSrv.new_submodel
        InputAlignedEffortSrv  = AlignedEffortSrv.new_submodel do
            provides InputDomainSrv
            input_port 'cmd_in_aligned_effort', '/base/LinearAngular6DCommand'
        end
        OutputAlignedEffortSrv = AlignedEffortSrv.new_submodel do
            provides OutputDomainSrv
            output_port 'cmd_out_aligned_effort', '/base/LinearAngular6DCommand'
        end

        BodyEffortSrv    = DomainSrv.new_submodel
        InputBodyEffortSrv  = BodyEffortSrv.new_submodel do
            provides InputDomainSrv
            input_port 'cmd_in_body_effort', '/base/LinearAngular6DCommand'
        end
        OutputBodyEffortSrv = BodyEffortSrv.new_submodel do
            provides OutputDomainSrv
            output_port 'cmd_out_body_effort', '/base/LinearAngular6DCommand'
        end

        def self.input_domain(&block)
            input_data_service(instance_eval(&block))
        end
        def self.output_domain(&block)
            output_data_service(instance_eval(&block))
        end

        INPUTS = Hash[
            :world => Hash[
                :pos => InputWorldPosSrv,
                :vel => InputWorldVelSrv],
            :aligned => Hash[
                :pos => InputAlignedPosSrv,
                :vel => InputAlignedVelSrv,
                :effort => InputAlignedEffortSrv],
            :body => Hash[
                :effort => InputBodyEffortSrv]]
        OUTPUTS = Hash[
            :world => Hash[
                :pos => OutputWorldPosSrv,
                :vel => OutputWorldVelSrv],
            :aligned => Hash[
                :pos => OutputAlignedPosSrv,
                :vel => OutputAlignedVelSrv,
                :effort => OutputAlignedEffortSrv],
            :body => Hash[
                :effort => OutputBodyEffortSrv]]

        def self.input_data_service(domains)
            data_service(domains, INPUTS)
        end
        def self.output_data_service(domains)
            data_service(domains, OUTPUTS)
        end
        def self.data_service(domain, base_data_services)
            if srv = data_services[domain]
                return srv
            end

            result = DomainSrv.new_submodel
            result.domain = domain
            [:world, :aligned, :body].each do |reference|
                [:pos, :vel, :effort].each do |quantity|
                    if !domain.get(reference, quantity).empty?
                        base_data_service = base_data_services[reference][quantity]
                        result.provides base_data_service
                    end
                end
            end
            data_services[domain] = result
            result
        end

        class << self
            # Cached set of services created by {data_service}
            #
            # @return [{Domain=>Model<DomainSrv>}]
            attr_reader :data_services
        end
        @data_services = Hash.new
    end
end

