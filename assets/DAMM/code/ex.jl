# This file was generated, do not modify it. # hide
#hideall
using WGLMakie, JSServe, UnicodeFun, SparseArrays, Observables
io = IOBuffer()
println(io, "~~~")
show(io, MIME"text/html"(), Page(exportable=true, offline=true))

# load DAMM, 3 params + porosity
include("DAMM_scaled_porosity.jl");
L = 40 # resolution
x = collect(range(1, length=L, stop=1))
[append!(x, collect(range(i, length=L, stop=i))) for i = 2:40]
x = reduce(vcat,x)
y = collect(range(0.0, length=L, stop=0.70))
y = repeat(y, outer=L)
x_range = hcat(x, y)
x = Int.(x_range[:, 1])
y_ax = collect(range(0.0, length=L, stop=0.70))
y = collect(range(1, length=L, stop=L))
y = repeat(y, outer=L)
y = Int.(y)
x_ax = collect(range(1, length=L, stop=L))

function create_plot(sliders1, sliders2, sliders3, sliders4, sliders5, sliders6)
	fig = Figure() #resolution = (1800, 1000))
	ax3D = LScene(fig[1,1]) # should be Axis3 instead of LScene, but bug
	surface!(ax3D, x_ax, y_ax, lift((AlphaSx, kMSx, kMO2, Porosity)->
		Matrix(sparse(x, y, DAMM(x_range, [AlphaSx, kMSx, kMO2, Porosity]))),
		sliders1.value, sliders2.value, sliders3.value, sliders4.value),
		colormap = Reverse(:Spectral), transparency = true, alpha = 0.2, shading = false) 

	wireframe!(ax3D, x_ax, y_ax, lift((AlphaSx, kMSx, kMO2, Porosity)->
		Matrix(sparse(x, y, DAMM(x_range, [AlphaSx, kMSx, kMO2, Porosity]))),
		sliders1.value, sliders2.value, sliders3.value, sliders4.value),
		   overdraw = true, transparency = true, color = (:black, 0.1));


	# remove these 3 lines when back to Axis3
	scene3D = ax3D.scene
	scale!(scene3D, 1,150, 7) 
	center!(scene3D)


	#ax3D.xlabel = to_latex("T_{soil} (°C)");
	#ax3D.ylabel = to_latex("\\theta (m^3 m^{-3})");
	#ax3D.zlabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");
	#zlims!(0, 25)
	#ylims!(0, 0.7)
	#scale!(ax3D, 1, 40, 1) 
	#center!(ax3D)

	p = [1,20,50,0.7]
	
	ax2D = Axis(fig[1,2])
	ts1 = collect(10:1:35)
	lines!(ax2D, ts1, lift(sm -> DAMM(
	 hcat(ts1, collect(range(sm, length=length(ts1), stop=sm))), p),
	 sliders5.value), color = :black)
	
	ax2D2 = Axis(fig[2,2])
	sm2 = collect(0.0:0.02:0.7)	
	lines!(ax2D2, sm2, lift(ts -> DAMM(
	 hcat(collect(range(ts, length=length(sm2), stop=ts)), sm2), p),
	 sliders6.value), color = :black)
	
	ylims!(ax2D, 0.0, 30.0)
	ylims!(ax2D2, 0.0, 30.0)
	ax2D.xlabel = to_latex("T_{soil} (°C)");
	ax2D.ylabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");
	ax2D2.ylabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");
	ax2D2.xlabel = to_latex("\\theta (m^3 m^{-3})");
	
	return fig
end

sr = [0.1:0.1:0.6, # alpha
	7:1:50, # kMsx
	0:1:50, # kmo2
	0.2:0.05:0.6, # porosity
	0.0:0.02:0.7, # soil moisture
	10:1:35]; # soil temperature

app = App() do session::Session    
	sliders1 = JSServe.Slider(sr[1])
	sliders2 = JSServe.Slider(sr[2])
	sliders3 = JSServe.Slider(sr[3])
	sliders4 = JSServe.Slider(sr[4])
	sliders5 = JSServe.Slider(sr[5])
	sliders6 = JSServe.Slider(sr[6])
	fig = create_plot(sliders1, sliders2, sliders3, sliders4, sliders5, sliders6)    
    	slider1 = DOM.div("alpha: ", sliders1, sliders1.value)
	slider2 = DOM.div("kMsx: ", sliders2, sliders2.value)
	slider3 = DOM.div("kMO2: ", sliders3, sliders3.value)
	slider4 = DOM.div("porosity: ", sliders4, sliders4.value)
	slider5 = DOM.div("soil moisture: ", sliders5, sliders5.value)
	slider6 = DOM.div("soil temperature: ", sliders6, sliders6.value)
    	return JSServe.record_states(session, DOM.div(slider1, slider2, slider3, slider4, slider5, slider6, fig))
end

show(io, MIME"text/html"(), app)
println(io, "~~~")
println(String(take!(io)))