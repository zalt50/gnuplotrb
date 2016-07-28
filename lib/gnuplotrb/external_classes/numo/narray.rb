if defined? Numo::NArray
  ##
  # See {Numo::NArray}[https://github.com/ruby-numo/narray]
  module Numo
    ##
    # Methods to take data for GnuplotRB plots.
    class NArray
      ##
      # Convert Numo::NArray to Gnuplot format.
      #
      # @return [String] array converted to Gnuplot format
      def to_gnuplot_points
        to_a.to_gnuplot_points
      end

      ##
      # Merge elements of self with corresponding elements from each argument.
      #
      # @param *list [Array] array of NArray
      # @return [Numo::NArray] new merged NArray
      def zip(*list)
        Numo::NArray[*to_a.zip(*list.map(&:to_a))]
          .transpose
      end
    end
  end
end
