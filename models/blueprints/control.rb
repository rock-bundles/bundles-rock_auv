module RockAUV
    extend Logger::Root("RockAUV", Logger::DEBUG)
    extend Logger::Forward

    module Control
        extend Logger::Hierarchy

        # Pipeline follower:
        #   - pipeline following itself is providing Yaw(aligned position) and Y(aligned position)
        #   - constant X(aligned velocity)
        #   - constant Pitch(world position), Roll(world position)
        #   - constant depth Z(world position)
        #
        # pipeline_following = PipelineFollower::Task ->
        #   AlignedPos(:Yaw,:Y)
        # pipeline_constant = ConstantMovement::Task ->
        #   AlignedVel(:X) | WorldPos(:Pitch,:Roll) | WorldPos(:Z)
        # Control.controller(
        #   pipeline_following,
        #   pipeline_constant, 
        #   hrov_base_controller)
        #
        # Auto-heading:
        #   - constant Yaw(world position), Pitch(world position), Roll(world position)
        #   - X,Y,Z manual control (e.g. joystick) (world position)
        #
        # Spiral descent
        #   - pitch,roll(aligned position) constant
        #   - yaw(aligned velocity) constant
        #   - X(aligned velocity) constant
        #

    end
end

require 'models/blueprints/control/axis'
require 'models/blueprints/control/domain'
require 'models/blueprints/control/data_service'
using_task_library 'auv_control'
require 'models/blueprints/control/netgen'
require 'models/blueprints/control/cascade'
require 'models/blueprints/control/constant'
