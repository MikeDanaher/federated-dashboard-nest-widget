namespace('Nest')

class Nest.Display
  @generateLogo: (config) ->
    "<i class=\"fa fa-home #{config.class}\" data-id=\"#{config.dataId}\"></i>"
