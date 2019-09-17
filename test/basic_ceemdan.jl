@testset "CEEMDAN" begin
    @testset "CEEMDAN Test 1" begin
        snrs = ones(10)./20
        n = 200
        s = CEEMDANSetting(n, 50, 10, 2, 10, snrs, 450)

        t = collect(range(0,1, length=n))
        x = zeros(n)

        for i=1:n
            x[i] = cos(22*pi*t[i]^2) + 6*t[i]^2
        end

        output = ceemdan(x, s)

        @test size(output, 2) == s.emd_setting.m

        recovered = zeros(n)

        for i=1:size(output, 2)
            recovered += output[:, i]
        end

        @test recovered == x || isapprox(recovered, x, rtol=0.10)
    end

    @testset "CEEMDAN Test 2" begin
        snrs = ones(250)./20
        N = 1024
        s = CEEMDANSetting(N, 50, 10, 10, 250, snrs, 200)

        function input_signal(x::Float64)
            omega = 2*pi/(N-1)
            return sin(17*omega*x)+0.5*(1.0-exp(-0.002*x))*sin(51*omega*x+1)
        end

        input = zeros(N)

        for i=1:N
            input[i] = input_signal(float(i))
        end


        output = ceemdan(input, s)

        @test size(output, 2) == s.emd_setting.m

        recovered = zeros(N)

        for i=1:size(output, 2)
            recovered += output[:, i]
        end

        @test isapprox(recovered,input, rtol=0.1)
    end
end

