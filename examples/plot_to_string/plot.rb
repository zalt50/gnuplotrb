require 'gnuplotrb'
include GnuplotRB

plot = Plot.new(['points.data', with: 'lines', title: 'Points from file'], title: 'Plotting to png')

plot_contents = plot.to_png(size: [600, 600])

File.binwrite('./gnuplot_gem.png', plot_contents)
