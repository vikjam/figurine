# Minimal plot of the Schelling housing segregation model
# Based upon the work of brenden17
# https://github.com/brenden17/Schelling-Segregation-Model/blob/master/model.ipynb
using Gadfly
using Cairo
using DataFrames
using Colors

srand(42)

const RED   = 0
const BLACK = 1

const TOTAL_AGENT = 500
const NEAR_AGENT  = 10
const PASS_AGENT  = 7

type Agent
    color::Int
    location::Array
    move::Bool
    Agent(color::Int) = new(color, rand(1, 2), true)
end

function euclidean(a::Agent, b::Agent)
    return sqrt(sum((a.location .- b.location) .^ 2))
end

function is_unhappy(target, agents)
    dist = sort!([(euclidean(target, agent), agent) for agent in agents])[1:NEAR_AGENT]
    return length(filter(x -> x[2].color == target.color, dist)) < PASS_AGENT ? true : false
end


function check_move(agents)
    println(length(filter(x -> x.move == true, agents)) == 0 ? false : true)
    return length(filter(x  -> x.move == true, agents)) == 0 ? false : true
end


function draw_agents(agents)
    df = DataFrame()
    df[:x]     = [agent.location[1] for agent in agents]
    df[:y]     = [agent.location[2] for agent in agents]
    df[:color] = [agent.color for agent in agents]
    plot(layer(x = df[df[:color] .== 0, :x],
        	   y = df[df[:color] .== 0, :y],
        	   Geom.point,
               Theme(default_color = colorant"#C69214")),
         layer(x = df[df[:color] .== 1, :x],
               y = df[df[:color] .== 1, :y],
               Geom.point,
               Theme(default_color = colorant"#182B49")),
        	   Guide.xticks(ticks = nothing),
        	   Guide.yticks(ticks = nothing),
        	   Guide.xlabel(""),
        	   Guide.ylabel(""))
end

agents = [n > TOTAL_AGENT / 2 ? Agent(RED): Agent(BLACK) for n = 1:TOTAL_AGENT]

while check_move(agents)
    for target in agents
        target.move = false
        while is_unhappy(target, agents)
            target.location = rand(1, 2)
            target.move     = true
        end
    end
end

schelling_plot = draw_agents(agents)
draw(PDF("schelling-segregation.pdf", 3.66inch, 2.16inch), schelling_plot)
