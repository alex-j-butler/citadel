require 'monkey/bootstrap_form/form_builder'

class Numeric
  def clamp(min, max)
    [[self, max].min, min].max
  end
end
