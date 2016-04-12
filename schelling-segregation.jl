# Minimal plot of the Schelling housing segregation model
# https://github.com/brenden17/Schelling-Segregation-Model/blob/master/model.ipynb
using Gadfly

srand(42)

const RED  = 0
const BLUE = 1

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
    return length(filter(x->x[2].color==target.color, dist)) < PASS_AGENT ? true : false
end


function check_move(agents)
    println(length(filter(x->x.move==true, agents)) == 0 ? false : true)
    return length(filter(x->x.move==true, agents)) == 0 ? false : true
end


function draw_agents(agents)
    x = [agent.location[1] for agent in agents]
    y = [agent.location[2] for agent in agents]
    c = [agent.color for agent in agents]
    plot(x     = x,
    	 y     = y,
    	 color = c,
    	 Geom.point,
    	 Guide.xticks(ticks = nothing),
    	 Guide.yticks(ticks = nothing),
    	 Guide.xlabel(""),
    	 Guide.ylabel(""))
end

function main()
    agents = [n > TOTAL_AGENT / 2 ? Agent(RED): Agent(BLUE) for n = 1:TOTAL_AGENT]

    while check_move(agents)
        for target in agents
            target.move = false
            while is_unhappy(target, agents)
                target.location = rand(1, 2)
                target.move     = true
            end
        end
    end
    draw_agents(agents)
end

main()


