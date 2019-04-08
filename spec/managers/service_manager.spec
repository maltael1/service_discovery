require 'rails_helper'

describe 'Service manager' do
    let(:service_variant) { create(:service_variant, code: "auth", name: "auth", token: "12345") }
    let(:service){ create(:service, service_variant: service_variant, status: Service.statuses[:registred], host: 'http://localhost:1', gate_host: 'http://localhost:1/gate', token: '1')}
    let(:confirmed_service){ create(:service, service_variant: service_variant, status: Service.statuses[:confirmed], host: 'http://localhost:2', gate_host: 'http://localhost:2', token: '2')}
    let(:activated_service){ create(:service, service_variant: service_variant, status: Service.statuses[:activated], host: 'http://localhost:3', gate_host: 'http://localhost:3', token: '3')}

    describe 'Register service method' do
        it "should be registred" do
            service = ServiceManager.register_service service_variant, 'http://localhost:3000', 'http://localhost:3000/gate'
            expect(service.status).to eq 'registred'
        end
    end

    describe 'Drop service method' do 
        it 'should be dropped' do
            ServiceManager.drop_service service
            expect(service.status).to eq 'lost'
        end

        it 'with two confirmed services' do
            confirmed_service
            activated_service
            ServiceManager.drop_service activated_service
            confirmed_service.reload
            expect(activated_service.status).to eq 'lost'
            expect(confirmed_service.status).to eq 'activated'
        end
    end

    describe 'Confirm service' do 

    end
end
