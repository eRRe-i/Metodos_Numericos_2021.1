### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 91a3130a-6fea-11eb-3cce-93c9085e6c72
using PlutoUI

# ╔═╡ 21aa8242-6ff4-11eb-06fc-5f8691841e50
using Calculus

# ╔═╡ beb8f7e8-6fdc-11eb-0cb1-c5a29d12b69a
begin
	using Plots
	gr()
end

# ╔═╡ 526fcd28-7211-11eb-3783-276f434f01f3
md"""# Métodos Numéricos
Professor: Marcelo Zamith. Github: [https://github.com/marzam](https://github.com/marzam)"""

# ╔═╡ 6085080e-722c-11eb-01e6-377ec4f0e433
begin
	md""" ###### por Leandro Bataglia. Github: [https://github.com/eRRe-i](https://github.com/eRRe-i)
	- Versão em notebook e PDF deste material: [github.com/eRRe-i/Metodos\_Numericos\_2021.1](https://github.com/eRRe-i/Metodos_Numericos_2021.1)
	
	- Versão em HTML dos exercícios de Métodos Numéricos [aqui](https://erre-i.github.io/Metodos_Numericos_2021.1/)
	"""
end

# ╔═╡ b21afa10-7214-11eb-3d6f-21d5d80a6f41
md""" #### Lista de exercícios 1 - Métodos aproximativos para zero da função"""

# ╔═╡ dad7e788-715b-11eb-09d4-1ba72a194c72
md""" Para executar esse script em seu notebook, assegure-se de estar com os pacotes **Plots**, **Calculus** e **PlutoUI**.
"""

# ╔═╡ 5cf8fef2-6fd4-11eb-0e43-c71707561e00
md"""
### Considere o $\ p(x) = x^5 - \frac{10}{9}x³ + \frac{5}{21}x$, ache o zero da função conforme os casos abaixo, considerando $\ \epsilon=10^{-5}$ 
"""

# ╔═╡ 1fb6d55c-7063-11eb-35f2-c51cea47d0b7
md"""Caso você esteja em um Pluto notebook, você pode usar as funcionalidades interativas do PlutoUI selecionando uma das opções abaixo. Caso deseje exportar para HTML, selecione a opção ```GIF```. Caso queira exportar para PDF, selecione ```PDF```.
"""

# ╔═╡ 22d082f0-7203-11eb-02d5-1770b6f99c6a
md"**atenção**: caso esteja em HTML estático, não é possível interagir com o documento :("

# ╔═╡ c5ecb616-714a-11eb-2ff2-b3253efc8aba
md""" **Selecione as opções abaixo:**
"""

# ╔═╡ a0c081f8-7157-11eb-3401-a38653c59fd8
md""" $(@bind cb_slider CheckBox()) Slider **|** $(@bind cb_gif CheckBox(default=true)) GIF **|** $(@bind cb_pdf CheckBox()) PDF"""

# ╔═╡ 64aa513e-6fd7-11eb-26ed-175c49263126
md""" ##### Passo 1: plotar o gráfico da função
"""

# ╔═╡ aa4849ca-6fec-11eb-0ae3-fdd0c256f2fd
f(x) = x^5-(10/9)*x^3 + (5/21)*x

# ╔═╡ 9b12d68a-6fda-11eb-2b3c-377d4c948d31
begin
	x = -1:0.00001:1
	plot(x, x-> f(x), legend=false, lw=1.5)
	plot!(x, x-> 0, legend=false, color="black", linewitdh=0.5)
end

# ╔═╡ b87d89b2-6fe5-11eb-1ebf-0165981c0996
md"""##### Passo 2: fazer as aproximações de acordo com o método escolhido
"""

# ╔═╡ 68cbfb56-7021-11eb-3665-53fa9c2868a9
md""" ### 1. Newton-Raphson [0.8]"""

# ╔═╡ 81e6f2c6-6fea-11eb-3a48-4b1512aaede1
function newton_raphson(f::Function, x::Float64; ε=1e-5)
	x_ant = 0.0
	x_list = Vector{Float64}(undef, 0)
	push!(x_list, x)
	while(abs(x - x_ant) >= ε)
	 	x1 = x - f(x) / derivative(f)(x)
		push!(x_list, x1)
		x, x_ant = x1, x
	end
	x_list
end

# ╔═╡ fd14248c-700d-11eb-0e68-b56d9e35211f
newton_raphson(f, 0.8)

# ╔═╡ 1c3d6280-701b-11eb-0e34-5f2698d7a9e9
function line_equation(f::Function, x::Float64, i::Int64, arr)
	x_1, y_1 = arr[i], f(arr[i])
	slope = derivative(f)(arr[i])
	indep = y_1 - slope * x_1
	return slope * x + indep
end

# ╔═╡ 85178ffe-714b-11eb-1ee0-c1713ec51558
begin
		md""" ##### Slider Iterativo"""
end

# ╔═╡ fd023532-7013-11eb-28ec-ab226721bfce
begin
	if cb_slider == true
		@bind u Slider(1:8)
	else md""" ```Essa célula ativará quando a checkbox estiver selecionada.```"""
	end
end

# ╔═╡ 873709ac-6ff2-11eb-0026-17c63f8d6ed6
begin
	if cb_slider == true
		arr = newton_raphson(f, 0.8)
		x_range = 0.5:0.0001:1.2
		xx_range = range(0.5, 1.2,length=50)
		plot(x_range, x_range -> f(x_range), legend=false, linewidth=1.5)
		plot!([0.90617], [0], marker=:circle, c=:green)
		plot!(xx_range, xx_range -> line_equation(f, xx_range, u, arr),
			c=:red, 
			linewidth=1, 
			xlabel=string("Slope: ", round((derivative(f)(arr[u])), digits=6)),
			title=string("Iteração ", u),
			xlims=(0.6, 1.2),
			ylims=(-0.25, 0.5) 
		)
	else md""" ```...```"""
	end
end

# ╔═╡ 6900d49c-7063-11eb-3966-957a52e09187
md""" ##### Animação em GIF """

# ╔═╡ 4aefbf72-7022-11eb-2558-e7091d757325
begin
	if cb_gif == true
		anim = @animate for u= 1:8
			arr = newton_raphson(f, 0.8)
			x_range = 0.5:0.0001:1.2
			xx_range = range(0.5, 1.2,length=50)
			plot(x_range, x_range -> f(x_range), legend=false, linewidth=1.5)
			plot!([-1, 2], [0,0], c=:black, linewidth=0.25)
			plot!([0.90617], [0], marker=:circle, c=:green)
			plot!(xx_range, xx_range -> line_equation(f, xx_range, u, arr),
				c=:red,
				linewidth=1, 
				xlabel=string("Slope: ", round((derivative(f)(arr[u])), digits=6)),
				title=string("Iteração ", u),
				xlims=(0.6, 1.2),
				ylims=(-0.25, 0.5)
			)
		end
		gif(anim, "anim.gif", fps = 1.2)
	else md""" ```Essa célula ativará quando a checkbox estiver selecionada.```"""
	end
end

# ╔═╡ 8d7cc8ec-71eb-11eb-115d-11de934f36e0
md""" ##### Imagens para PDF
"""

# ╔═╡ de5382d8-71eb-11eb-0a94-4f6a5c887f4d
if cb_pdf
	newton_arr = []
	arr_= newton_raphson(f, 0.8)
	for u = 1:8
		arr = newton_raphson(f, 0.8)
		x_range = 0.5:0.0001:1.2
		xx_range = range(0.5, 1.2,length=50)
		a1 = plot(x_range, x_range -> f(x_range), legend=false, linewidth=1.5)
		plot!([-1, 2], [0,0], c=:black, linewidth=0.25)
		plot!([0.90617], [0], marker=:circle, c=:green)
		plot!(xx_range, xx_range -> line_equation(f, xx_range, u, arr),
			c=:red,
			linewidth=1, 
			xlabel=string("Slope: ", round((derivative(f)(arr[u])), digits=6)),
			title=string("Iteração ", u),
			xlims=(0.6, 1.2),
			ylims=(-0.25, 0.5)
		)
		push!(newton_arr, a1)
	end
	plot(newton_arr[1], newton_arr[2], newton_arr[3], newton_arr[4])
else md""" ```Essas células ativarão quando a checkbox estiver selecionada.```"""
end

# ╔═╡ dd516b54-71ee-11eb-2bc2-19d219a5ee97
if cb_pdf
	plot(newton_arr[5], newton_arr[6], newton_arr[7], newton_arr[8])
else md""" ```...```"""
end

# ╔═╡ ab5bf252-7021-11eb-289e-93d94e2c1643
md""" ### 2. Bicessão [-0.75, -0.25]"""

# ╔═╡ f14a174c-705d-11eb-20eb-112767345f2a
function bisection(f::Function, a::Float64, b::Float64, ε=1e-5)
	range_list = Array{Array{Float64}}(undef,0)
	push!(range_list, [a, b])
	x = (a + b)/2
	while(f(x) != 0 && abs(a-b) > ε)
		if(f(x)*f(a) < 0)
			b = x
		else
			a = x
		end
		push!(range_list, [a, b])
		x = (a + b)/2
	end
	range_list
end

# ╔═╡ d05edb8e-7004-11eb-35de-bb1a5b1b0ffc
bisec_list = bisection(f, -0.75, -0.25)

# ╔═╡ ad85dd60-7149-11eb-0bfd-4bf74d39dc78
md""" ##### Slider Iterativo
"""

# ╔═╡ 5fa9bc16-7071-11eb-3da2-55f1454864d4
if cb_slider == true
	@bind v Slider(1:length(bisec_list))
else md""" ```Essa célula ativará quando a checkbox estiver selecionada.```"""
end

# ╔═╡ a1a47ab4-706e-11eb-1359-8b74cf0a46d4
if cb_slider == true
	begin
		v_range = -0.80:0.0001:-0.20
			vv_range = range(0.04, -0.04, length=length(bisec_list))
			plot(v_range, v_range -> f(v_range), legend=false, linewidth=1.5)
			plot!([-1, 1], [0,0], c=:black, linewidth=0.25)
			plot!([-0.5384], [0], marker=:circle, c=:green)
			plot!(bisec_list[v], [vv_range[v], vv_range[v]],
				c=:red, 
				linewidth=3, 
				xlabel=string("Range: ", bisec_list[v]),
				title=string("Iteração ", v),
				ylims=(-0.05, 0.05),
				xlims=(-0.85, -0.15),
				markershape= :square
			)
	end
else md""" ```...```"""
end


# ╔═╡ bae43cfe-7149-11eb-1f68-4965435b2241
md""" ##### Animação em GIF
"""

# ╔═╡ 575d6cc0-7073-11eb-0dfe-ffbe73a2842f
if cb_gif == true
	anim2 = @animate for v = 1:length(bisec_list)
		v_range = -0.80:0.0001:-0.20
		vv_range = range(0.04, -0.04, length=length(bisec_list))
		plot(v_range, v_range -> f(v_range), legend=false, linewidth=1.5)
		plot!([-1, 1], [0,0], c=:black, linewidth=0.25)
		plot!([-0.5384], [0], marker=:circle, c=:green)
		plot!(bisec_list[v], [vv_range[v], vv_range[v]],
			c=:red, 
			linewidth=3, 
			xlabel=string("[a, b] = ", bisec_list[v]),
			title=string("Iteração ", v),
			ylims=(-0.05, 0.05),
			xlims=(-0.85, -0.15),
			markershape= :square
		)
		end
	gif(anim2, "bisec1.gif", fps=1.2)
	else md""" ```Essa célula ativará quando a checkbox estiver selecionada.```"""
end

# ╔═╡ bd51ce92-718b-11eb-35e0-95bf5634ac23
md""" ##### Imagens para PDF
"""

# ╔═╡ 5c8e0c56-7181-11eb-3f7b-37d01b141853
if cb_pdf
	bisec_arr = []
	for v = 1:length(bisec_list)
		v_range = -0.80:0.0001:-0.20
		vv_range = range(0.04, -0.04, length=length(bisec_list))
		p2 = plot(v_range, v_range -> f(v_range), legend=false, linewidth=1.5, fmt=:png)
		plot!([-1, 1], [0,0], c=:black, linewidth=0.25)
		plot!([-0.5384], [0], marker=:circle, c=:green)
		plot!(bisec_list[v], [vv_range[v], vv_range[v]],
			c=:red, 
			linewidth=3, 
			xlabel=string("[a, b] = ", bisec_list[v]),
			title=string("Iteração ", v),
			ylims=(-0.05, 0.05),
			xlims=(-0.85, -0.15),
			markershape= :square,
			fmt=:png
		)
		push!(bisec_arr, p2)
	end
	plot(bisec_arr[1], bisec_arr[2], bisec_arr[3], bisec_arr[4])
else md""" ```Essas células ativarão quando a checkbox estiver selecionada.```"""
end

# ╔═╡ 5869a1e6-7189-11eb-31a2-d9a17b1bd459
if cb_pdf
	plot(bisec_arr[5], bisec_arr[6], bisec_arr[7], bisec_arr[8])
else md"""```...```"""
end

# ╔═╡ 6e70a7dc-7189-11eb-0d7a-f9a9199d80e8
if cb_pdf
	plot(bisec_arr[9], bisec_arr[10], bisec_arr[11], bisec_arr[12], guidefont=8)
else md"""```...```"""
end

# ╔═╡ dd3c3c7c-7183-11eb-3e43-81aade740b0a
if cb_pdf
	plot(bisec_arr[13], bisec_arr[14], bisec_arr[15], bisec_arr[16], guidefont=7)
else md"""```...```"""	
end

# ╔═╡ f62f94f6-718b-11eb-0368-294f110ae492
if cb_pdf
	plot(bisec_arr[17], size=(300,200), guidefont=7)
else md"""```...```"""
end

# ╔═╡ c5083092-7021-11eb-1c6e-ddede5c470fc
md""" ### 3. Falsa Posição [-0.25, 0.25]"""

# ╔═╡ d104b366-7003-11eb-27fd-e3efdd3b0b26
function false_pos(f::Function, a::Float64, b::Float64, ε=1e-5)
	range_list = Array{Array{Float64}}(undef,0)
	push!(range_list, [a, b])
	x_ant=0.0
	x = (a * f(b) - b * f(a))/ (f(b) - f(a))
	while(f(x) != 0 &&  abs(x - x_ant)/abs(x) > ε)
		if(f(x) < 0)
			a = x
		else
			b = x
		end
		push!(range_list, [a, b])
		x, x_ant = a * f(b) - b * f(a)/ f(b) - f(a), x
	end
	range_list
end

# ╔═╡ 0337064e-7005-11eb-1fdc-0f97b6f1b849
false_pos_list = false_pos(f, -0.25, 0.25)

# ╔═╡ f0a853ac-7149-11eb-0722-ffc3a82c2ff6
md""" ##### Slider Interativo
"""

# ╔═╡ 519673bc-7094-11eb-1a72-2be23c16c82d
if cb_slider == true
	@bind w Slider(1:length(false_pos_list))
else md""" ```Essa célula ativará quando a checkbox estiver selecionada.```"""
end

# ╔═╡ 4873d3aa-7158-11eb-0137-fb5233fd7d2a
md""" ##### Animação em GIF
"""

# ╔═╡ 16d0ef50-7094-11eb-3b85-25190f37a610
if cb_gif == true
	anim4 = @animate for w = 1:length(false_pos_list)
		w_range = -0.30:0.0001:0.30
		ww_range = range(-0.02, 0.02, length=length(false_pos_list)+1)
		plot(w_range, w_range -> f(w_range), legend=false, linewidth=1.5)
		plot!([-1, 1], [0,0], c=:black, linewidth=0.25)
		plot!([0], [0], marker=:circle, c=:green)
		plot!(false_pos_list[w], [ww_range[w], ww_range[w]],
			c=:red, 
			linewidth=3, 
			xlabel=string("[a, b] = ", false_pos_list[w]),
			title=string("Iteração ", w),
			ylims=(-0.05, 0.05),
			xlims=(-0.30, 0.30),
			markershape= :square
		)
	end
	gif(anim4, "fal_pos.gif", fps=1.2)
else md""" ```Essa célula ativará quando a checkbox estiver selecionada.```"""
end

# ╔═╡ 2d861e2e-71ea-11eb-321e-2dc49271ad34
md""" ##### Imagens para PDF
"""

# ╔═╡ 414ec67e-71ea-11eb-090b-fd50c3f06cf2
if cb_pdf == true
	falpos_arr = []
	for w = 1:length(false_pos_list)
	w_range = -0.30:0.0001:0.30
	ww_range = range(-0.02, 0.02, length=length(false_pos_list)+1)
	a = plot(w_range, w_range -> f(w_range), legend=false, linewidth=1.5)
	plot!([-1, 1], [0,0], c=:black, linewidth=0.25)
	plot!([0], [0], marker=:circle, c=:green)
	plot!(false_pos_list[w], [ww_range[w], ww_range[w]],
		c=:red, 
		linewidth=3, 
		xlabel=string("[a, b] = ", false_pos_list[w]),
		title=string("Iteração ", w),
		ylims=(-0.05, 0.05),
		xlims=(-0.30, 0.30),
		markershape= :square
	)
		push!(falpos_arr, a)
	end
	plot(falpos_arr[1])
else md""" ```Essas células ativarão quando a checkbox estiver selecionada.```"""
end

# ╔═╡ e489fae0-7021-11eb-02d6-e3650822d6c3
md""" ### 4. Bicessão [0.2, 0.6] """

# ╔═╡ 0c7d9766-7005-11eb-01db-f36dcbaa693e
bisec2 = bisection(f, 0.2, 0.6)

# ╔═╡ 1ebecbcc-7159-11eb-20a9-b9bc00354113
md""" ##### Slider interativo
"""

# ╔═╡ 8c19888e-7081-11eb-1acd-31ee22a8e9f3
if cb_slider == true
	@bind y Slider(1:length(bisec2));
else md""" ```Essa célula ativará quando a checkbox estiver selecionada.```"""
end

# ╔═╡ ee8c868e-7157-11eb-1bb1-15667bce9569
if cb_slider == true
	w_range = -0.30:0.0001:0.30
			ww_range = range(-0.02, 0.02, length=length(false_pos_list)+1)
			plot(w_range, w_range -> f(w_range), legend=false, linewidth=1.5)
			plot!([-1, 1], [0,0], c=:black, linewidth=0.25)
			plot!([0], [0], marker=:circle, c=:green)
			plot!(false_pos_list[w], [ww_range[w], ww_range[w]],
				c=:red, 
				linewidth=3, 
				xlabel=string("[a, b] = ", false_pos_list[w]),
				title=string("Iteração ", y),
				ylims=(-0.05, 0.05),
				xlims=(-0.30, 0.30),
				markershape= :square
			)
else md""" ```...```"""
end

# ╔═╡ 6b6f2b70-7081-11eb-0b0f-817a51bb6bc9
if cb_slider == true
	y_range = 0.15:0.0001:0.65
	yy_range = range(0.04, -0.04, length=length(bisec2))
	plot(y_range, y_range -> f(y_range), legend=false, linewidth=1.5)
	plot!([-1, 1], [0,0], c=:black, linewidth=0.25)
	plot!([0.5384], [0], marker=:circle, c=:green)
	plot!(bisec2[y], [yy_range[y], yy_range[y]],
		c=:red, 
		linewidth=3, 
		xlabel=string("[a, b] = ", bisec2[y]),
		title=string("Iteração ", y),
		ylims=(-0.05, 0.05),
		xlims=(0.15, 0.65),
		markershape= :square
	)
else md""" ```...```"""
end

# ╔═╡ a3753172-7158-11eb-22df-1bc30923baa7
md""" ##### Animação em GIF
"""

# ╔═╡ 220f63d8-7076-11eb-098c-43f7718ba1c8
if cb_gif == true
	anim3 = @animate for y = 1:length(bisec2)
		y_range = 0.15:0.0001:0.65
		yy_range = range(0.04, -0.04, length=length(bisec2))
		plot(y_range, y_range -> f(y_range), legend=false, linewidth=1.5)
		plot!([-1, 1], [0,0], c=:black, linewidth=0.25)
		plot!([0.5384], [0], marker=:circle, c=:green)
		plot!(bisec2[y], [yy_range[y], yy_range[y]],
			c=:red, 
			linewidth=3, 
			xlabel=string("[a, b] = ", bisec2[y]),
			title=string("Iteração ", y),
			ylims=(-0.05, 0.05),
			xlims=(0.15, 0.65),
			markershape= :square
		)
	end
	gif(anim3, "bisec2.gif", fps=1.2)
else md""" ```Essa célula ativará quando a checkbox estiver selecionada.```"""
end

# ╔═╡ 02ed79c4-71f3-11eb-0227-7156b44576f6
md""" ##### Imagens para PDF
"""

# ╔═╡ 17be4876-71f3-11eb-1880-b5e18379bcf3
if cb_pdf
	bisec2_arr = []
	for y = 1:length(bisec2)
		y_range = 0.15:0.0001:0.65
		yy_range = range(0.04, -0.04, length=length(bisec2))
		p4 = plot(y_range, y_range -> f(y_range), legend=false, linewidth=1.5, fmt=:png)
		plot!([-1, 1], [0,0], c=:black, linewidth=0.25)
		plot!([-0.5384], [0], marker=:circle, c=:green)
		plot!(bisec2[y], [yy_range[y], yy_range[y]],
			c=:red, 
			linewidth=3, 
			xlabel=string("[a, b] = ", bisec2[y]),
			title=string("Iteração ", y),
			ylims=(-0.05, 0.05),
			xlims=(0.15, 0.65),
			markershape= :square,
		)
		push!(bisec2_arr, p4)
	end
	plot(bisec2_arr[1], bisec2_arr[2], bisec2_arr[3], bisec2_arr[4])
else md""" ```Essas células ativarão quando a checkbox estiver selecionada.```"""
end

# ╔═╡ 2cebfbd4-71f4-11eb-285e-dbe73373df3f
if cb_pdf
	plot(bisec2_arr[5], bisec2_arr[6], bisec2_arr[7], bisec2_arr[8], guidefont=7)
else md""" ```...```"""
end

# ╔═╡ ce1ab4aa-71f4-11eb-34dc-1d051e499b0f
if cb_pdf
	plot(bisec2_arr[9], bisec2_arr[10], bisec2_arr[11], bisec2_arr[12], guidefont=7)
else md""" ```...```"""
end

# ╔═╡ e238e10a-71f4-11eb-0e4a-b303ff291c31
if cb_pdf
	plot(bisec2_arr[13], bisec2_arr[14], bisec2_arr[15], bisec2_arr[16], guidefont=7)
else md""" ```...```"""
end

# ╔═╡ ed972b6a-71f4-11eb-04f2-0fbc880ae344
if cb_pdf
	plot(bisec2_arr[17], guidefont=7, size=(300,200))
else md""" ```...```"""
end

# ╔═╡ f054943e-7021-11eb-1b92-dd44f64df344
md""" ### 5. Secante [0.8, 1.0]"""

# ╔═╡ da103912-7003-11eb-2b0c-7df1d934a89b
function sec(f::Function, a::Float64, b::Float64, ε=1e-5)
	x_list = Array{Array{Float64}}(undef,0)
	push!(x_list, [a , b])
	while(abs(f(a)) >= ε)
	 	x = b - (f(b) * (b - a))/(f(b) - f(a))
		a, b = b, x
		push!(x_list, [a, b])
	end
	x_list
end

# ╔═╡ 23ba3070-71f5-11eb-244f-cf63027a833a
function line(x1::Float64, y1::Float64, x2::Float64, y2::Float64)
	m::Float64 = (y2 - y1) / (x2 - x1)
	b::Float64 = y1 - x1 * m
	f = function solve(x::Float64, m::Float64 = m, b::Float64 = b)
		return m * x + b
	end
	return f
end

# ╔═╡ 34e60474-7005-11eb-04ad-57adb9a8b38b
sec_list = sec(f, 0.8, 1.0)

# ╔═╡ d4296f00-7148-11eb-021f-63e7e205b710
md""" ##### Slider interativo
"""

# ╔═╡ 81b4d226-70be-11eb-1c76-63487a9e3638
if cb_slider == true
	@bind z Slider(1:length(sec_list))
else md""" ```Essa célula ativará quando a checkbox estiver selecionada.```"""
end

# ╔═╡ 838bc728-70c6-11eb-3aa1-4543f3815f17
if cb_slider == true
	z_range = 0:0.0001:2
	plot(z_range, z_range -> f(z_range), legend=false, linewidth=1.5)
	plot!([-1, 2], [0,0], c=:black, linewidth=0.25)
	plot!([0.90617], [0], marker=:circle, c=:green)
	plot!([-2, 2], [
		line(sec_list[z][1], f(sec_list[z][1]), sec_list[z][2], f(sec_list[z][2]))(-2.0),
		line(sec_list[z][1], f(sec_list[z][1]), sec_list[z][2], f(sec_list[z][2]))(2.0)
			],
		c=:red, 
		linewidth=1.5, 
		xlabel=string("[a, b] = ", sec_list[z]),
		title=string("Iteração ", z),
		xlims=(0.75, 1.05),
		ylims=(-0.15, 0.15),
	)
else md""" ```...```"""
end

# ╔═╡ ee9eb9b2-7148-11eb-1e92-f5db626d25bd
md""" ##### Animação em GIF
"""

# ╔═╡ 4a9cc08e-70cb-11eb-14b4-bb0f1978eb6e
if cb_gif == true
	anim5 = @animate for z = 1:length(sec_list)
		z_range = 0:0.0001:2
	plot(z_range, z_range -> f(z_range), legend=false, linewidth=1.5)
	plot!([-1, 2], [0,0], c=:black, linewidth=0.25)
	plot!([0.90617], [0], marker=:circle, c=:green)
	z_slope = (f(sec_list[z][2]) - f(sec_list[z][1])) / (sec_list[z][2] - sec_list[z][1])
	plot!([-2, 2], [
		line(sec_list[z][1], f(sec_list[z][1]), sec_list[z][2], f(sec_list[z][2]))(-2.0),
		line(sec_list[z][1], f(sec_list[z][1]), sec_list[z][2], f(sec_list[z][2]))(2.0)
			],
		c=:red, 
		linewidth=1.5, 
		xlabel=string("[a, b] = ", sec_list[z]),
		title=string("Iteração ", z),
		xlims=(0.75, 1.05),
		ylims=(-0.15, 0.15),
	)
	end
	gif(anim5, "sec.gif", fps=1.2)
else md""" ```Essa célula ativará quando a checkbox estiver selecionada.```"""
end

# ╔═╡ 0e9b8608-71f5-11eb-388a-b386fa4d81e1
md""" ##### Imagens para PDF
"""

# ╔═╡ 0738b9aa-71fd-11eb-3067-5f03539382fd
if cb_pdf == true
	sec_arr = []
	for z = 1:length(sec_list)
		z_range = 0:0.0001:2
		p = plot(z_range, z_range -> f(z_range), legend=false, linewidth=1.5)
		plot!([-1, 2], [0,0], c=:black, linewidth=0.25)
		plot!([0.90617], [0], marker=:circle, c=:green)
		z_slope = (f(sec_list[z][2]) - f(sec_list[z][1])) / (sec_list[z][2] - sec_list[z][1])
		plot!([-2, 2], [
			line(sec_list[z][1], f(sec_list[z][1]), sec_list[z][2], f(sec_list[z][2]))(-2.0),
			line(sec_list[z][1], f(sec_list[z][1]), sec_list[z][2], f(sec_list[z][2]))(2.0)
				],
			c=:red, 
			linewidth=1.5, 
			xlabel=string("[a, b] = ", sec_list[z]),
			title=string("Iteração ", z),
			xlims=(0.75, 1.05),
			ylims=(-0.15, 0.15),
		)
		push!(sec_arr, p)
	end
	plot(sec_arr[1], sec_arr[2], sec_arr[3], sec_arr[4], guidefont=7)
else md""" ```Essa células ativarão quando a checkbox estiver selecionada.```"""
end

# ╔═╡ 0344fbe8-7201-11eb-3be9-5f1ffaf1310a
if cb_pdf == true
	plot(sec_arr[5], sec_arr[6], sec_arr[7], sec_arr[8], guidefont=7)
else md""" ```...```"""
end

# ╔═╡ Cell order:
# ╟─526fcd28-7211-11eb-3783-276f434f01f3
# ╟─6085080e-722c-11eb-01e6-377ec4f0e433
# ╟─b21afa10-7214-11eb-3d6f-21d5d80a6f41
# ╟─dad7e788-715b-11eb-09d4-1ba72a194c72
# ╠═91a3130a-6fea-11eb-3cce-93c9085e6c72
# ╠═21aa8242-6ff4-11eb-06fc-5f8691841e50
# ╠═beb8f7e8-6fdc-11eb-0cb1-c5a29d12b69a
# ╟─5cf8fef2-6fd4-11eb-0e43-c71707561e00
# ╟─1fb6d55c-7063-11eb-35f2-c51cea47d0b7
# ╟─22d082f0-7203-11eb-02d5-1770b6f99c6a
# ╟─c5ecb616-714a-11eb-2ff2-b3253efc8aba
# ╟─a0c081f8-7157-11eb-3401-a38653c59fd8
# ╟─64aa513e-6fd7-11eb-26ed-175c49263126
# ╠═aa4849ca-6fec-11eb-0ae3-fdd0c256f2fd
# ╟─9b12d68a-6fda-11eb-2b3c-377d4c948d31
# ╟─b87d89b2-6fe5-11eb-1ebf-0165981c0996
# ╟─68cbfb56-7021-11eb-3665-53fa9c2868a9
# ╠═81e6f2c6-6fea-11eb-3a48-4b1512aaede1
# ╠═fd14248c-700d-11eb-0e68-b56d9e35211f
# ╟─1c3d6280-701b-11eb-0e34-5f2698d7a9e9
# ╟─85178ffe-714b-11eb-1ee0-c1713ec51558
# ╟─fd023532-7013-11eb-28ec-ab226721bfce
# ╟─873709ac-6ff2-11eb-0026-17c63f8d6ed6
# ╟─6900d49c-7063-11eb-3966-957a52e09187
# ╟─4aefbf72-7022-11eb-2558-e7091d757325
# ╟─8d7cc8ec-71eb-11eb-115d-11de934f36e0
# ╟─de5382d8-71eb-11eb-0a94-4f6a5c887f4d
# ╟─dd516b54-71ee-11eb-2bc2-19d219a5ee97
# ╟─ab5bf252-7021-11eb-289e-93d94e2c1643
# ╠═f14a174c-705d-11eb-20eb-112767345f2a
# ╠═d05edb8e-7004-11eb-35de-bb1a5b1b0ffc
# ╟─ad85dd60-7149-11eb-0bfd-4bf74d39dc78
# ╟─5fa9bc16-7071-11eb-3da2-55f1454864d4
# ╟─a1a47ab4-706e-11eb-1359-8b74cf0a46d4
# ╟─bae43cfe-7149-11eb-1f68-4965435b2241
# ╟─575d6cc0-7073-11eb-0dfe-ffbe73a2842f
# ╟─bd51ce92-718b-11eb-35e0-95bf5634ac23
# ╟─5c8e0c56-7181-11eb-3f7b-37d01b141853
# ╟─5869a1e6-7189-11eb-31a2-d9a17b1bd459
# ╟─6e70a7dc-7189-11eb-0d7a-f9a9199d80e8
# ╟─dd3c3c7c-7183-11eb-3e43-81aade740b0a
# ╟─f62f94f6-718b-11eb-0368-294f110ae492
# ╟─c5083092-7021-11eb-1c6e-ddede5c470fc
# ╠═d104b366-7003-11eb-27fd-e3efdd3b0b26
# ╠═0337064e-7005-11eb-1fdc-0f97b6f1b849
# ╟─f0a853ac-7149-11eb-0722-ffc3a82c2ff6
# ╟─519673bc-7094-11eb-1a72-2be23c16c82d
# ╟─ee8c868e-7157-11eb-1bb1-15667bce9569
# ╟─4873d3aa-7158-11eb-0137-fb5233fd7d2a
# ╟─16d0ef50-7094-11eb-3b85-25190f37a610
# ╟─2d861e2e-71ea-11eb-321e-2dc49271ad34
# ╟─414ec67e-71ea-11eb-090b-fd50c3f06cf2
# ╟─e489fae0-7021-11eb-02d6-e3650822d6c3
# ╟─0c7d9766-7005-11eb-01db-f36dcbaa693e
# ╟─1ebecbcc-7159-11eb-20a9-b9bc00354113
# ╟─8c19888e-7081-11eb-1acd-31ee22a8e9f3
# ╟─6b6f2b70-7081-11eb-0b0f-817a51bb6bc9
# ╟─a3753172-7158-11eb-22df-1bc30923baa7
# ╟─220f63d8-7076-11eb-098c-43f7718ba1c8
# ╟─02ed79c4-71f3-11eb-0227-7156b44576f6
# ╟─17be4876-71f3-11eb-1880-b5e18379bcf3
# ╟─2cebfbd4-71f4-11eb-285e-dbe73373df3f
# ╟─ce1ab4aa-71f4-11eb-34dc-1d051e499b0f
# ╟─e238e10a-71f4-11eb-0e4a-b303ff291c31
# ╟─ed972b6a-71f4-11eb-04f2-0fbc880ae344
# ╟─f054943e-7021-11eb-1b92-dd44f64df344
# ╠═da103912-7003-11eb-2b0c-7df1d934a89b
# ╟─23ba3070-71f5-11eb-244f-cf63027a833a
# ╠═34e60474-7005-11eb-04ad-57adb9a8b38b
# ╟─d4296f00-7148-11eb-021f-63e7e205b710
# ╟─81b4d226-70be-11eb-1c76-63487a9e3638
# ╟─838bc728-70c6-11eb-3aa1-4543f3815f17
# ╟─ee9eb9b2-7148-11eb-1e92-f5db626d25bd
# ╟─4a9cc08e-70cb-11eb-14b4-bb0f1978eb6e
# ╟─0e9b8608-71f5-11eb-388a-b386fa4d81e1
# ╟─0738b9aa-71fd-11eb-3067-5f03539382fd
# ╟─0344fbe8-7201-11eb-3be9-5f1ffaf1310a
