require 'test_helper'

class Cater::ServiceTest < Minitest::Test
  class ServiceClass
    include ::Cater::Service

    required do 
      boolean :should_fail 
    end

    def call(should_fail:)
      if should_fail
        error!(message: "ERROR")
      else
        false
      end
    end
  end

  def setup
  end

  def test_call_on_class_returns_instance
    instance = ServiceClass.call(should_fail: 1)
    assert instance.kind_of? ServiceClass
  end

  def test_success?
    instance = ServiceClass.call(should_fail: false)
    assert instance.success?
    refute instance.error?
  end

  def test_error?
    instance = ServiceClass.call(should_fail: true)
    assert instance.error?
    refute instance.success?
  end

  def test_responses_to_errors
    instance = ServiceClass.call(should_fail: 1)
    instance.respond_to? :errors
  end

  def test_content_of_errors
    instance = ServiceClass.call(should_fail: 1)
    assert_equal ["ERROR"], instance.errors.messages[:base]
  end

  def test_responses_to_success?
    instance = ServiceClass.call(should_fail: 1)
    instance.respond_to? :success?
  end

  def test_responses_to_error?
    instance = ServiceClass.call(should_fail: 1)
    instance.respond_to? :error?
  end

  def test_responses_to_validators?
    instance = ServiceClass.call(should_fail: 1)
    instance.respond_to? :input_validators
  end

  def test_validation_failed?
    instance = ServiceClass.call(should_fail: 'Abc')
    assert_equal ["should be boolean"], instance.errors.messages[:should_fail]
  end
end
