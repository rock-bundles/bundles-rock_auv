module RockAUV
    module Control
        # Representation of a set of axis
        #
        # It is used to build a control {Domain}
        class Axis
            attr_accessor :encoded

            SHIFTS = Hash[
                :x => 0,
                :y => 1,
                :z => 2,
                :yaw => 3,
                :pitch => 4,
                :roll => 5]
            MASK = (1 << 6) - 1

            # Initializes an {Axis} structure directly from its encoded value
            def self.from_raw(encoded)
                p =  new
                p.encoded = encoded
                p
            end

            # Initializes an {Axis} structure based on a set of named parameters
            def initialize(*parameters)
                @encoded = 0
                parameters.each { |name| set(name.to_sym) }
            end

            # Declares that the x axis is being controlled
            def x!(set); set(:x) end
            # Tests whether x is being controlled
            # @return [Boolean]
            def x?; get(:x) end
            # Declares that the y axis is being controlled
            def y!(set); set(:y) end
            # Tests whether y is being controlled
            # @return [Boolean]
            def y?; get(:y) end
            # Declares that the z axis is being controlled
            def z!(set); set(:z) end
            # Tests whether z is being controlled
            # @return [Boolean]
            def z?; get(:z) end
            # Declares that the yaw axis is being controlled
            def yaw!(set); set(:yaw) end
            # Tests whether yaw is being controlled
            # @return [Boolean]
            def yaw?; get(:yaw) end
            # Declares that the pitch axis is being controlled
            def pitch!(set); set(:pitch) end
            # Tests whether pitch is being controlled
            # @return [Boolean]
            def pitch?; get(:pitch) end
            # Declares that the roll axis is being controlled
            def roll!(set); set(:roll) end
            # Tests whether roll is being controlled
            # @return [Boolean]
            def roll?; get(:roll) end

            # Declares that one of the axis is being controlled
            # @param [Symbol] parameter
            def set(axis)
                @encoded |= (1 << SHIFTS[axis.to_sym])
            end
            # Tests whether one of the axis is being controlled
            # @param [Symbol] parameter
            # @return [Boolean]
            def get(axis)
                encoded & (1 << SHIFTS[axis.to_sym])
            end

            # Tests whether some axis are set
            def empty?
                encoded == 0
            end

            def |(a)
                self.class.from_raw(encoded | a.encoded)
            end

            def &(a)
                self.class.from_raw(encoded & a.encoded)
            end

            def ==(value)
                if value.respond_to?(:encoded)
                    encoded == value.encoded
                else
                    encoded == value
                end
            end

            def to_s
                SHIFTS.map { |name, shift| name.to_s if (encoded & (1 << shift) != 0) }.
                    compact.join(",")
            end
        end
    end
end
