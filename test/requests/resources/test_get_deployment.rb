require File.expand_path '../../test_helper', __dir__

# Test class for Get Deployment Request
class TestGetDeployment < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    @rmc_client = @service.instance_variable_get(:@rmc)
    @deployments = @rmc_client.deployments
    @resource_group = 'fog-test-rg'
    @deployment_name = 'fog-test-deployment'
  end

  def test_list_deployment_success
    mocked_response = ApiStub::Requests::Resources::Deployment.create_deployment_response(@rmc_client)
    @deployments.stub :get, mocked_response do
      assert_equal @service.get_deployment(@resource_group, @deployment_name), mocked_response
    end
  end

  def test_list_deployment_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @deployments.stub :get, response do
      assert_raises(RuntimeError) { @service.get_deployment(@resource_group, @deployment_name) }
    end
  end
end
