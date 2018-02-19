module API
  module V1
    class DemosController < APIController
      def show
        @demo = Demo.find(params[:id])

        render json: @demo, serializer: DemoSerializer
      end

      def create
        @demo = Demo.new(demo_params)

        if @demo.save
          ImportDemoJob.perform_later @demo
          render json: @demo, serializer: DemoSerializer, status: :created
        else
          render json: @demo.errors, status: :unprocessable_entity
        end
      end

      private

      def demo_params
        params.require(:demo).permit(:demo, :uploaded_by, :created_at)
      end
    end
  end
end
