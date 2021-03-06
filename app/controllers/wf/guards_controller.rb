# frozen_string_literal: true

require_dependency "wf/application_controller"

module Wf
  class GuardsController < ApplicationController
    breadcrumb "Workflows", :workflows_path
    def new
      @arc = Wf::Arc.find(params[:arc_id])
      @guard = @arc.guards.new
      breadcrumb @arc.workflow.name, workflow_path(@arc.workflow)
      breadcrumb @arc.name, workflow_arc_path(@arc.workflow, @arc)
    end

    def create
      @arc = Wf::Arc.find(params[:arc_id])
      gp = guard_params.merge(fieldable: GlobalID::Locator.locate(guard_params[:fieldable]))
      @guard = @arc.guards.new(gp.merge(workflow: @arc.workflow))
      redirect_to workflow_arc_path(@arc.workflow, @arc), notice: "only out direction arc can set guard!" unless @arc.out?
      if @guard.save
        redirect_to workflow_arc_path(@arc.workflow, @arc), notice: "guard was successfully created."
      else
        render :new
      end
    end

    def destroy
      @arc = Wf::Arc.find(params[:arc_id])
      @guard = @arc.guards.find(params[:id])
      @guard.destroy
      render js: "window.location.reload()"
    end

    def edit
      @arc = Wf::Arc.find(params[:arc_id])
      @guard = @arc.guards.find(params[:id])
      breadcrumb @arc.workflow.name, workflow_path(@arc.workflow)
      breadcrumb @arc.name, workflow_arc_path(@arc.workflow, @arc)
    end

    def update
      @arc = Wf::Arc.find(params[:arc_id])
      gp = guard_params.merge(fieldable: GlobalID::Locator.locate(guard_params[:fieldable]))
      @guard = @arc.guards.find(params[:id])
      if @guard.update(gp)
        redirect_to workflow_arc_path(@arc.workflow, @arc), notice: "guard was successfully created."
      else
        render :edit
      end
    end

    private

      def guard_params
        params.fetch(:guard, {}).permit(:fieldable, :fieldable_type, :fieldable_id, :op, :value, :exp)
      end
  end
end
