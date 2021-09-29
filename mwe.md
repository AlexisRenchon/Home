+++
title = "WGLMakie + JSServe"
+++

```julia:ex
using WGLMakie, JSServe, UnicodeFun, SparseArrays, Observables
io = IOBuffer()
println(io, "~~~")
show(io, MIME"text/html"(), Page(exportable=true, offline=true))

xs = LinRange(0, 10, 100)
ys = LinRange(0, 10, 100)
zs = [cos(x) * sin(y) for x in xs, y in ys]

function create_plot(sliders1)
	fig = Figure() 	
	colors = [:Spectral, :deep, :balance, :haline]
	ax3D = Axis3(fig[1,1])
	surface!(ax3D, xs, ys, zs, colormap = lift(c -> colors[c], sliders1.value))
	return fig
end

sr = 1:1:4

app = App() do session::Session    
	sliders1 = JSServe.Slider(sr)
	fig = create_plot(sliders1)    
    	slider1 = DOM.div("value: ", sliders1, sliders1.value)
	return JSServe.record_states(session, DOM.div(slider1, fig))
end

show(io, MIME"text/html"(), app)
println(io, "~~~")
println(String(take!(io)))
```
\textoutput{ex}
