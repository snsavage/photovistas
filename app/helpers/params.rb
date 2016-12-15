module ParamHelpers
  def filter_params(params, allow = [])
    params ||= {}

    params.keep_if do |key, value|
      allow.include?(key)
    end
  end
end
