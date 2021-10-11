+++
title = "COSORE DAMM"
+++

```julia:ex
#hideall
using WGLMakie, JSServe, FileIO
io = IOBuffer()
println(io, "~~~")
show(io, MIME"text/html"(), Page(exportable=true, offline=true))

# I will need to add FileIO to Project.toml

imgpaths = readdir("COSORE_DAMM", join = true)
# n = length(imgpaths)
n = 10
img = []
[push!(img, rotr90(load(imgpaths[i]))) for i = 1:n]

function create_plot(slider)
	fig = Figure(resolution = (1300, 1000));
	ax = Axis(fig[1,1]);
	p = image!(ax, lift(x -> img[x], slider.value));
	return fig
end

app = App() do session::Session    
	slider = JSServe.Slider(1:n)
	fig = create_plot(slider)    
    	slider1 = DOM.div("Site: ", slider, slider.value)
	return JSServe.record_states(session, DOM.div(slider1, fig))
end

show(io, MIME"text/html"(), app)
println(io, "~~~")
println(String(take!(io)))
```
\textoutput{ex}
