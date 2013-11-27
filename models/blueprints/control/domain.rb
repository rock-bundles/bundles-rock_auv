import_types_from 'auv_control'
module RockAUV
    module Control
        # Representation of a control domain
        #
        # This represents each of the possible control domain (world/pos,
        # body/effort) as well as sets of axis that are being controlled
        class Domain
            SHIFTS = Hash[
                [:world, :pos]      => 0 * 6,
                [:world, :vel]      => 1 * 6,
                [:world, :effort]   => 2 * 6,
                [:aligned, :pos]    => 3 * 6,
                [:aligned, :vel]    => 4 * 6,
                [:aligned, :effort] => 5 * 6,
                [:body, :pos]       => 6 * 6,
                [:body, :vel]       => 7 * 6,
                [:body, :effort]    => 8 * 6]

            # @return [Bignum]
            attr_accessor :encoded

            # Creates a new domain from an encoded value
            def self.from_raw(encoded)
                d = Domain.new
                d.encoded = encoded
                d
            end

            # @return [Axis]
            def get(reference, quantity)
                shift = SHIFTS[[reference, quantity]]
                if !shift
                    raise ArgumentError, "don't know anything about #{reference}:#{quantity}"
                end
                encoded_axis = (encoded >> shift) & Axis::MASK
                Axis.from_raw(encoded_axis)
            end

            # @overload Domain.new
            #   creates a new empty domain
            # @overload Domain.new(reference, quantity, axis)
            #   creates a new domain that controls a single axis
            #   @param [Symbol] reference the control reference frame. One of
            #     :world, :aligned or :body
            #   @param [Symbol] quantity the quantity being controlled. One of
            #     :pos, :vel or :effort
            #   @param [Symbol] axis the axis being controlled. One of
            #     :x, :y, :z, :yaw, :pitch, :roll
            def initialize(*args)
                @encoded = 0
                if !args.empty?
                    if args.size != 3
                        raise ArgumentError, "expected no arguments or 3, got #{args.size}"
                    end
                    reference, domain, parameters = *args
                    @encoded |= (parameters.encoded << SHIFTS[[reference, domain]])
                end
            end

            # Merges two control domains
            #
            # @param [Domain] domain the merged domain
            # @return [Domain] the merged domain
            # @raise ArgumentError if self and domain control the same
            #   reference/quantity/axis
            def |(domain)
                if (domain.encoded & encoded) != 0
                    raise ArgumentError, "cannot merge #{self} with #{domain}: some parameters are part of both domains"
                end
                Domain.from_raw(encoded | domain.encoded)
            end

            # Enumerates all parts of the control domain that are actually
            # controlled
            #
            # @yieldparam [Symbol] reference the reference part
            #   (:world,:aligned,:body)
            # @yieldparam [Symbol] quantity the quantity part
            #   (:pos,:vel,:effort)
            # @yieldparam [Axis] axis the axis being controlled
            # @return [void]
            def each
                return enum_for(__method__) if !block_given?
                SHIFTS.each_key do |reference, quantity|
                    axis = get(reference, quantity)
                    if !axis.empty?
                        yield(reference, quantity, axis)
                    end
                end
                nil
            end

            def hash; encoded.hash end
            def eql?(p); encoded.eql?(p.encoded) end
            def ==(p); encoded == p.encoded end
            def to_s
                SHIFTS.map do |(reference,domain),shift|
                    encoded_axis = (encoded >> shift) & Axis::MASK
                    if encoded_axis != 0
                        reference.to_s.capitalize  +
                            domain.to_s.capitalize +
                            "(#{Axis.from_raw(encoded >> shift)})"
                    end
                end.compact.join("|")
            end
        end

    end
end

