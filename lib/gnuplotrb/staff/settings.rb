module GnuplotRB
  ##
  # This module takes care of path to gnuplot executable and checking its version.
  module Settings
    ##
    # GnuplotRB can work with Gnuplot 5.0+
    MIN_GNUPLOT_VERSION = 5.0

    class << self
      DEFAULT_MAX_FIT_DELAY = 5
      DEFAULT_GNUPLOT_PATH = 'gnuplot'
      ##
      # For heavy calculations max_fit_delay may be increased.
      attr_writer :max_fit_delay
      ##
      # Get max fit delay.
      #
      # Max fit delay (5s by default) is used inside Fit::fit function.
      # If it waits for output more than max_fit_delay seconds
      # this behaviour is considered as errorneus.
      # @return [Integer] seconds to wait for output
      def max_fit_delay
        @max_fit_delay ||= DEFAULT_MAX_FIT_DELAY
      end

      ##
      # Get path that should be used to run gnuplot executable.
      # Default value: 'gnuplot'.
      # @return [String] path to gnuplot executable
      def gnuplot_path
        self.gnuplot_path = DEFAULT_GNUPLOT_PATH unless defined?(@gnuplot_path)
        @gnuplot_path
      end

      ##
      # Set path to gnuplot executable.
      # @param path [String] path to gnuplot executable
      # @return given path
      def gnuplot_path=(path)
        validate_version(path)
        opts = { stdin_data: "set term\n" }
        @available_terminals = Open3.capture2e(path, **opts)
                                    .first
                                    .scan(/[:\n] +([a-z][^ ]+)/)
                                    .map(&:first)
        @gnuplot_path = path
      end

      ##
      # Get list of terminals (png, html, qt, jpeg etc) available for this gnuplot.
      # @return [Array of String] array of terminals available for this gnuplot
      def available_terminals
        gnuplot_path
        @available_terminals
      end

      ##
      # Get gnuplot version. Uses gnuplot_path to find gnuplot executable.
      # @return [Numeric] gnuplot version
      def version
        gnuplot_path
        @version
      end

      ##
      # @private
      # Validate gnuplot version. Compares current gnuplot's
      # version with ::MIN_GNUPLOT_VERSION. Throws exception if version is
      # less than min.
      #
      # @param path [String] path to gnuplot executable
      def validate_version(path)
        @version = IO.popen("#{path} --version")
                     .read
                     .match(/gnuplot ([^ ]+)/)[1]
                     .to_f
        raise(
          ArgumentError,
          "Your Gnuplot version is #{@version}, please update it to at least 5.0"
        ) if @version < MIN_GNUPLOT_VERSION
      rescue Errno::ENOENT
        raise(
          ArgumentError,
          "Can't find Gnuplot executable. Please make sure it's installed and added to PATH."
        )
      end
    end
  end
end
