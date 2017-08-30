######################################:ne_connection####################################################################
# The purpose of this file is to define commonly used and created constraints used in gas flow models
##########################################################################################################

" Constraint that states a flow direction must be chosen "
function constraint_flow_direction_choice{T}(gm::GenericGasModel{T}, i)
    yp = gm.var[:yp][i]
    yn = gm.var[:yn][i]

    c1 = @constraint(gm.model, yp + yn >= 1)
    c2 = @constraint(gm.model, yp + yn <= 1)
    return Set([c1,c2;]) # checked
end

" Constraint that states a flow direction must be chosen for new edges "
function constraint_flow_direction_choice_ne{T}(gm::GenericGasModel{T}, i)
    yp = gm.var[:yp_ne][i]
    yn = gm.var[:yn_ne][i]

    c1 = @constraint(gm.model, yp + yn >= 1)
    c2 = @constraint(gm.model, yp + yn <= 1)
    return Set([c1,c2;]) # checked
end

" constraints on pressure drop across pipes "
function constraint_on_off_pressure_drop{T}(gm::GenericGasModel{T}, pipe_idx)
    pipe = gm.ref[:connection][pipe_idx]
    i_junction_idx = pipe["f_junction"]
    j_junction_idx = pipe["t_junction"]

    yp = gm.var[:yp][pipe_idx]
    yn = gm.var[:yn][pipe_idx]

    pi = gm.var[:p][i_junction_idx]
    pj = gm.var[:p][j_junction_idx]

    pd_min = pipe["pd_min"]
    pd_max = pipe["pd_max"]

    c1 = @constraint(gm.model, (1-yp) * pd_min <= pi - pj)
    c2 = @constraint(gm.model, pi - pj <= (1-yn)* pd_max)

    return Set([c1,c2])  # checked (though one is reversed of the other)
end

" constraints on pressure drop across pipes "
function constraint_on_off_pressure_drop_fixed_direction{T}(gm::GenericGasModel{T}, pipe_idx)
    pipe = gm.ref[:connection][pipe_idx]

    i_junction_idx = pipe["f_junction"]
    j_junction_idx = pipe["t_junction"]

    yp = pipe["yp"]
    yn = pipe["yn"]

    pi = gm.var[:p][i_junction_idx]
    pj = gm.var[:p][j_junction_idx]

    pd_min = pipe["pd_min"]
    pd_max = pipe["pd_max"]

    c1 = @constraint(gm.model, (1-yp) * pd_min <= pi - pj)
    c2 = @constraint(gm.model, pi - pj <= (1-yn)* pd_max)

    return Set([c1,c2])  # checked (though one is reversed of the other)
end

" constraints on pressure drop across pipes "
function constraint_on_off_pressure_drop_ne{T}(gm::GenericGasModel{T}, pipe_idx)
    pipe = gm.ref[:ne_connection][pipe_idx]

    i_junction_idx = pipe["f_junction"]
    j_junction_idx = pipe["t_junction"]

    yp = gm.var[:yp_ne][pipe_idx]
    yn = gm.var[:yn_ne][pipe_idx]

    pi = gm.var[:p][i_junction_idx]
    pj = gm.var[:p][j_junction_idx]

    pd_min = pipe["pd_min"]
    pd_max = pipe["pd_max"]

    c1 = @constraint(gm.model, (1-yp) * pd_min <= pi - pj)
    c2 = @constraint(gm.model, pi - pj <= (1-yn)* pd_max)

    return Set([c1,c2])  # checked (though one is reversed of the other)
end

" constraints on pressure drop across pipes when the direction is fixed "
function constraint_on_off_pressure_drop_ne_fixed_direction{T}(gm::GenericGasModel{T}, pipe_idx)
    pipe = gm.ref[:ne_connection][pipe_idx]

    i_junction_idx = pipe["f_junction"]
    j_junction_idx = pipe["t_junction"]

    yp = pipe["yp"]
    yn = pipe["yn"]

    pi = gm.var[:p][i_junction_idx]
    pj = gm.var[:p][j_junction_idx]

    pd_min = pipe["pd_min"]
    pd_max = pipe["pd_max"]

    c1 = @constraint(gm.model, (1-yp) * pd_min <= pi - pj)
    c2 = @constraint(gm.model, pi - pj <= (1-yn)* pd_max)

    return Set([c1,c2])  # checked (though one is reversed of the other)
end

" constraints on flow across pipes "
function constraint_on_off_pipe_flow_direction{T}(gm::GenericGasModel{T}, pipe_idx)
    pipe = gm.ref[:connection][pipe_idx]

    i_junction_idx = pipe["f_junction"]
    j_junction_idx = pipe["t_junction"]

    yp = gm.var[:yp][pipe_idx]
    yn = gm.var[:yn][pipe_idx]
    f  = gm.var[:f][pipe_idx]

    max_flow = gm.ref[:max_flow]
    pd_max = pipe["pd_max"]
    pd_min = pipe["pd_min"]
    w = pipe["resistance"]

    c1 = @constraint(gm.model, -(1-yp)*min(max_flow, sqrt(w*max(pd_max, abs(pd_min)))) <= f)
    c2 = @constraint(gm.model, f <= (1-yn)*min(max_flow, sqrt(w*max(pd_max, abs(pd_min)))))

    return Set([c1, c2])    # checked (though one is reveresed of the other)
end

" constraints on flow across pipes where the directions are fixed "
function constraint_on_off_pipe_flow_direction_fixed_direction{T}(gm::GenericGasModel{T}, pipe_idx)
    pipe = gm.ref[:connection][pipe_idx]

    i_junction_idx = pipe["f_junction"]
    j_junction_idx = pipe["t_junction"]

    yp = pipe["yp"]
    yn = pipe["yn"]
    f = gm.var[:f][pipe_idx]

    max_flow = gm.ref[:max_flow]
    pd_max = pipe["pd_max"]
    pd_min = pipe["pd_min"]
    w = pipe["resistance"]

    c1 = @constraint(gm.model, -(1-yp)*min(max_flow, sqrt(w*max(pd_max, abs(pd_min)))) <= f)
    c2 = @constraint(gm.model, f <= (1-yn)*min(max_flow, sqrt(w*max(pd_max, abs(pd_min)))))

    return Set([c1, c2])    # checked (though one is reveresed of the other)
end

" constraints on flow across pipes "
function constraint_on_off_pipe_flow_direction_ne{T}(gm::GenericGasModel{T}, pipe_idx)
    pipe = gm.ref[:ne_connection][pipe_idx]

    i_junction_idx = pipe["f_junction"]
    j_junction_idx = pipe["t_junction"]

    yp = gm.var[:yp_ne][pipe_idx]
    yn = gm.var[:yn_ne][pipe_idx]
    f  = gm.var[:f_ne][pipe_idx]

    max_flow = gm.ref[:max_flow]
    pd_max = pipe["pd_max"]
    pd_min = pipe["pd_min"]
    w = pipe["resistance"]

    c1 = @constraint(gm.model, -(1-yp)*min(max_flow, sqrt(w*max(pd_max, abs(pd_min)))) <= f)
    c2 = @constraint(gm.model, f <= (1-yn)*min(max_flow, sqrt(w*max(pd_max, abs(pd_min)))))

    return Set([c1, c2])    # checked (though one is reveresed of the other)
end

" constraints on flow across pipes when directions are fixed "
function constraint_on_off_pipe_flow_direction_ne_fixed_direction{T}(gm::GenericGasModel{T}, pipe_idx)
    pipe = gm.ref[:ne_connection][pipe_idx]

    i_junction_idx = pipe["f_junction"]
    j_junction_idx = pipe["t_junction"]

    yp = pipe["yp"]
    yn = pipe["yn"]
    f  = gm.var[:f_ne][pipe_idx]

    max_flow = gm.ref[:max_flow]
    pd_max = pipe["pd_max"]
    pd_min = pipe["pd_min"]
    w = pipe["resistance"]

    c1 = @constraint(gm.model, -(1-yp)*min(max_flow, sqrt(w*max(pd_max, abs(pd_min)))) <= f)
    c2 = @constraint(gm.model, f <= (1-yn)*min(max_flow, sqrt(w*max(pd_max, abs(pd_min)))))

    return Set([c1, c2])    # checked (though one is reveresed of the other)
end

" constraints on flow across compressors "
function constraint_on_off_compressor_flow_direction{T}(gm::GenericGasModel{T}, c_idx)
    compressor = gm.ref[:connection][c_idx]

    i_junction_idx = compressor["f_junction"]
    j_junction_idx = compressor["t_junction"]

    yp = gm.var[:yp][c_idx]
    yn = gm.var[:yn][c_idx]
    f  = gm.var[:f][c_idx]

    c1 = @constraint(gm.model, -(1-yp)*gm.ref[:max_flow] <= f)
    c2 = @constraint(gm.model, f <= (1-yn)*gm.ref[:max_flow])

    return Set([c1, c2])      # checked (though 1 is reversed)
end

" constraints on flow across compressors when directions are constants "
function constraint_on_off_compressor_flow_direction_fixed_direction{T}(gm::GenericGasModel{T}, c_idx)
    compressor = gm.ref[:connection][c_idx]

    i_junction_idx = compressor["f_junction"]
    j_junction_idx = compressor["t_junction"]

    yp = compressor["yp"]
    yn = compressor["yn"]
    f = gm.var[:f][c_idx]

    c1 = @constraint(gm.model, -(1-yp)*gm.ref[:max_flow] <= f)
    c2 = @constraint(gm.model, f <= (1-yn)*gm.ref[:max_flow])

    return Set([c1, c2])      # checked (though 1 is reversed)
end

" constraints on flow across compressors "
function constraint_on_off_compressor_flow_direction_ne{T}(gm::GenericGasModel{T}, c_idx)
    compressor = gm.ref[:ne_connection][c_idx]
    i_junction_idx = compressor["f_junction"]
    j_junction_idx = compressor["t_junction"]

    yp = gm.var[:yp_ne][c_idx]
    yn = gm.var[:yn_ne][c_idx]
    f  = gm.var[:f_ne][c_idx]

    c1 = @constraint(gm.model, -(1-yp)*gm.ref[:max_flow] <= f)
    c2 = @constraint(gm.model, f <= (1-yn)*gm.ref[:max_flow])

    return Set([c1, c2])      # checked (though 1 is reversed)
end

" constraints on flow across compressors when the directions are constants "
function constraint_on_off_compressor_flow_direction_ne_fixed_direction{T}(gm::GenericGasModel{T}, c_idx)
    compressor = gm.ref[:ne_connection][c_idx]

    i_junction_idx = compressor["f_junction"]
    j_junction_idx = compressor["t_junction"]

    yp = compressor["yp"]
    yn = compressor["yn"]
    f = gm.var[:f_ne][c_idx]

    c1 = @constraint(gm.model, -(1-yp)*gm.ref[:max_flow] <= f)
    c2 = @constraint(gm.model, f <= (1-yn)*gm.ref[:max_flow])

    return Set([c1, c2])      # checked (though 1 is reversed)
end

" enforces pressure changes bounds that obey compression ratios "
function constraint_on_off_compressor_ratios{T}(gm::GenericGasModel{T}, c_idx)
    compressor = gm.ref[:connection][c_idx]
    i_junction_idx = compressor["f_junction"]
    j_junction_idx = compressor["t_junction"]

    i = gm.ref[:junction][i_junction_idx]
    j = gm.ref[:junction][j_junction_idx]

    pi = gm.var[:p][i_junction_idx]
    pj = gm.var[:p][j_junction_idx]
    yp = gm.var[:yp][c_idx]
    yn = gm.var[:yn][c_idx]

    max_ratio = compressor["c_ratio_max"]
    min_ratio = compressor["c_ratio_min"]

    c1 = @constraint(gm.model, pj - max_ratio^2*pi <= (1-yp)*(j["pmax"]^2 - max_ratio^2*i["pmin"]^2))
    c2 = @constraint(gm.model, min_ratio^2*pi - pj <= (1-yp)*(min_ratio^2*i["pmax"]^2 - j["pmin"]^2))
    c3 = @constraint(gm.model, pi - max_ratio^2*pj <= (1-yn)*(i["pmax"]^2 - max_ratio^2*j["pmin"]^2))
    c4 = @constraint(gm.model, min_ratio^2*pj - pi <= (1-yn)*(min_ratio^2*j["pmax"]^2 - i["pmin"]^2))

    return Set([c1,c2,c3,c4])
end

" constraints on pressure drop across control valves "
function constraint_on_off_compressor_ratios_ne{T}(gm::GenericGasModel{T}, c_idx)
    compressor = gm.ref[:ne_connection][c_idx]
    i_junction_idx = compressor["f_junction"]
    j_junction_idx = compressor["t_junction"]

    i = gm.ref[:junction][i_junction_idx]
    j = gm.ref[:junction][j_junction_idx]

    pi = gm.var[:p][i_junction_idx]
    pj = gm.var[:p][j_junction_idx]
    yp = gm.var[:yp_ne][c_idx]
    yn = gm.var[:yn_ne][c_idx]
    zc = gm.var[:zc][c_idx]

    max_ratio = compressor["c_ratio_max"]
    min_ratio = compressor["c_ratio_min"]

    c1 = @constraint(gm.model,  pj - (max_ratio*pi) <= (2-yp-zc)*j["pmax"]^2)
    c2 = @constraint(gm.model,  (min_ratio*pi) - pj <= (2-yp-zc)*(min_ratio*i["pmax"]^2) )
    c3 = @constraint(gm.model,  pi - (max_ratio*pj) <= (2-yn-zc)*i["pmax"]^2)
    c4 = @constraint(gm.model,  (min_ratio*pj) - pi <= (2-yn-zc)*(min_ratio*j["pmax"]^2))

    return Set([c1, c2, c3, c4])
end

" on/off constraint for compressors when the flow direction is constant "
function constraint_on_off_compressor_ratios_fixed_direction{T}(gm::GenericGasModel{T}, c_idx)
    compressor = gm.ref[:connection][c_idx]
    i_junction_idx = compressor["f_junction"]
    j_junction_idx = compressor["t_junction"]

    i = gm.ref[:junction][i_junction_idx]
    j = gm.ref[:junction][j_junction_idx]

    pi = gm.var[:p][i_junction_idx]
    pj = gm.var[:p][j_junction_idx]
    yp = compressor["yp"]
    yn = compressor["yn"]

    max_ratio = compressor["c_ratio_max"]
    min_ratio = compressor["c_ratio_min"]

    c1 = @constraint(gm.model, pj - max_ratio^2*pi <= (1-yp)*(j["pmax"]^2 - max_ratio^2*i["pmin"]^2))
    c2 = @constraint(gm.model, min_ratio^2*pi - pj <= (1-yp)*(min_ratio^2*i["pmax"]^2 - j["pmin"]^2))
    c3 = @constraint(gm.model, pi - max_ratio^2*pj <= (1-yn)*(i["pmax"]^2 - max_ratio^2*j["pmin"]^2))
    c4 = @constraint(gm.model, min_ratio^2*pj - pi <= (1-yn)*(min_ratio^2*j["pmax"]^2 - i["pmin"]^2))

    return Set([c1,c2,c3,c4])
end

" standard flow balance equation where demand and production is fixed "
function constraint_junction_flow_balance{T}(gm::GenericGasModel{T}, i)
    junction = gm.ref[:junction][i]
    junction_branches = gm.ref[:junction_connections][i]

    f_branches = collect(keys(filter( (a, connection) -> connection["f_junction"] == i, gm.ref[:connection])))
    t_branches = collect(keys(filter( (a, connection) -> connection["t_junction"] == i, gm.ref[:connection])))

    p = gm.var[:p]
    f = gm.var[:f]

    c1 = @constraint(gm.model, junction["qgfirm"] - junction["qlfirm"] >= sum(f[a] for a in f_branches) - sum(f[a] for a in t_branches) )
    c2 = @constraint(gm.model, junction["qgfirm"] - junction["qlfirm"] <= sum(f[a] for a in f_branches) - sum(f[a] for a in t_branches) )

    return Set([c1,c2;])
end

" standard flow balance equation where demand and production is fixed "
function constraint_junction_flow_balance_ne{T}(gm::GenericGasModel{T}, i)
    junction = gm.ref[:junction][i]
    junction_branches = gm.ref[:junction_connections][i]

    f_branches = collect(keys(filter( (a, connection) -> connection["f_junction"] == i, gm.ref[:connection])))
    t_branches = collect(keys(filter( (a, connection) -> connection["t_junction"] == i, gm.ref[:connection])))

    f_branches_ne = collect(keys(filter( (a, connection) -> connection["f_junction"] == i, gm.ref[:ne_connection])))
    t_branches_ne = collect(keys(filter( (a, connection) -> connection["t_junction"] == i, gm.ref[:ne_connection])))

    p = gm.var[:p]
    f = gm.var[:f]
    f_ne = gm.var[:f_ne]
    c1 = @constraint(gm.model, junction["qgfirm"] - junction["qlfirm"] >= sum(f[a] for a in f_branches) - sum(f[a] for a in t_branches) + sum(f_ne[a] for a in f_branches_ne) - sum(f_ne[a] for a in t_branches_ne) )
    c2 = @constraint(gm.model, junction["qgfirm"] - junction["qlfirm"] <= sum(f[a] for a in f_branches) - sum(f[a] for a in t_branches) + sum(f_ne[a] for a in f_branches_ne) - sum(f_ne[a] for a in t_branches_ne) )

    return Set([c1,c2;])
end

" standard flow balance equation where demand and production is fixed "
function constraint_junction_flow_balance_ls{T}(gm::GenericGasModel{T}, i)
    junction = gm.ref[:junction][i]
    junction_branches = gm.ref[:junction_connections][i]

    f_branches = collect(keys(filter( (a, connection) -> connection["f_junction"] == i, gm.ref[:connection])))
    t_branches = collect(keys(filter( (a, connection) -> connection["t_junction"] == i, gm.ref[:connection])))

    p = gm.var[:p]
    f = gm.var[:f]
    ql = 0
    qg = 0
    if junction["qlmin"] != junction["qlmax"]
        ql = gm.var[:ql][i]
    end
    if junction["qgmin"] != junction["qgmax"]
        qg = gm.var[:qg][i]
    end
    ql_firm = junction["qlfirm"]
    qg_firm = junction["qgfirm"]

    c1 = @constraint(gm.model, qg_firm - ql_firm + qg - ql >= sum(f[a] for a in f_branches) - sum(f[a] for a in t_branches) )
    c2 = @constraint(gm.model, qg_firm - ql_firm + qg - ql <= sum(f[a] for a in f_branches) - sum(f[a] for a in t_branches) )

    return Set([c1,c2;])
end

" standard flow balance equation where demand and production is fixed "
function constraint_junction_flow_balance_ne_ls{T}(gm::GenericGasModel{T}, i)
    junction = gm.ref[:junction][i]
    junction_branches = gm.ref[:junction_connections][i]

    f_branches = collect(keys(filter( (a, connection) -> connection["f_junction"] == i, gm.ref[:connection])))
    t_branches = collect(keys(filter( (a, connection) -> connection["t_junction"] == i, gm.ref[:connection])))

    f_branches_ne = collect(keys(filter( (a, connection) -> connection["f_junction"] == i, gm.ref[:ne_connection])))
    t_branches_ne = collect(keys(filter( (a, connection) -> connection["t_junction"] == i, gm.ref[:ne_connection])))

    p = gm.var[:p]
    f = gm.var[:f]
    f_ne = gm.var[:f_ne]

    ql = 0
    qg = 0
    if junction["qlmin"] != junction["qlmax"]
        ql = gm.var[:ql][i]
    end
    if junction["qgmin"] != junction["qgmax"]
        qg = gm.var[:qg][i]
    end

    ql_firm = junction["qlfirm"]
    qg_firm = junction["qgfirm"]

    c1 = @constraint(gm.model, qg_firm - ql_firm + qg - ql >= sum(f[a] for a in f_branches) - sum(f[a] for a in t_branches) + sum(f_ne[a] for a in f_branches_ne) - sum(f_ne[a] for a in t_branches_ne) )
    c2 = @constraint(gm.model, qg_firm - ql_firm + qg - ql <= sum(f[a] for a in f_branches) - sum(f[a] for a in t_branches) + sum(f_ne[a] for a in f_branches_ne) - sum(f_ne[a] for a in t_branches_ne) )

    return Set([c1,c2;])
end

" constraints on flow across short pipes "
function constraint_on_off_short_pipe_flow_direction{T}(gm::GenericGasModel{T}, pipe_idx)
    pipe = gm.ref[:connection][pipe_idx]
    i_junction_idx = pipe["f_junction"]
    j_junction_idx = pipe["t_junction"]

    yp = gm.var[:yp][pipe_idx]
    yn = gm.var[:yn][pipe_idx]
    f = gm.var[:f][pipe_idx]
    max_flow = gm.ref[:max_flow]

    c1 = @constraint(gm.model, -max_flow*(1-yp) <= f)
    c2 = @constraint(gm.model, f <= max_flow*(1-yn))

    return Set([c1, c2])
end

" constraints on flow across short pipes when the directions are constants "
function constraint_on_off_short_pipe_flow_direction_fixed_direction{T}(gm::GenericGasModel{T}, pipe_idx)
    pipe = gm.ref[:connection][pipe_idx]
    i_junction_idx = pipe["f_junction"]
    j_junction_idx = pipe["t_junction"]

    yp = pipe["yp"]
    yn = pipe["yn"]
    f = gm.var[:f][pipe_idx]
    max_flow = gm.ref[:max_flow]

    c1 = @constraint(gm.model, -max_flow*(1-yp) <= f)
    c2 = @constraint(gm.model, f <= max_flow*(1-yn))

    return Set([c1, c2])
end

" constraints on pressure drop across pipes "
function constraint_short_pipe_pressure_drop{T}(gm::GenericGasModel{T}, pipe_idx)
    pipe = gm.ref[:connection][pipe_idx]
    i_junction_idx = pipe["f_junction"]
    j_junction_idx = pipe["t_junction"]

    pi = gm.var[:p][i_junction_idx]
    pj = gm.var[:p][j_junction_idx]

    c1 = @constraint(gm.model,  pi >= pj)
    c2 = @constraint(gm.model,  pi <= pj)
    return Set([c1,c2])
end

" constraints on flow across valves "
function constraint_on_off_valve_flow_direction{T}(gm::GenericGasModel{T}, valve_idx)
    valve = gm.ref[:connection][valve_idx]
    i_junction_idx = valve["f_junction"]
    j_junction_idx = valve["t_junction"]

    yp = gm.var[:yp][valve_idx]
    yn = gm.var[:yn][valve_idx]
    f = gm.var[:f][valve_idx]
    v = gm.var[:v][valve_idx]

    max_flow = gm.ref[:max_flow]

    c1 = @constraint(gm.model, -max_flow*(1-yp) <= f)
    c2 = @constraint(gm.model, f <= max_flow*(1-yn))
    c3 = @constraint(gm.model, -max_flow*v <= f )
    c4 = @constraint(gm.model, f <= max_flow*v)

    return Set([c1, c2, c3, c4])
end

" constraints on flow across valves when directions are constants "
function constraint_on_off_valve_flow_direction_fixed_direction{T}(gm::GenericGasModel{T}, valve_idx)
    valve = gm.ref[:connection][valve_idx]
    i_junction_idx = valve["f_junction"]
    j_junction_idx = valve["t_junction"]

    yp = valve["yp"]
    yn = valve["yn"]
    f = gm.var[:f][valve_idx]
    v = gm.var[:v][valve_idx]

    max_flow = gm.ref[:max_flow]

    c1 = @constraint(gm.model, -max_flow*(1-yp) <= f <= max_flow*(1-yn))
    c2 = @constraint(gm.model, -max_flow*v <= f <= max_flow*v)

    return Set([c1, c2])
end

" constraints on pressure drop across valves "
function constraint_on_off_valve_pressure_drop{T}(gm::GenericGasModel{T}, valve_idx)
    valve = gm.ref[:connection][valve_idx]
    i_junction_idx = valve["f_junction"]
    j_junction_idx = valve["t_junction"]

    i = gm.ref[:junction][i_junction_idx]
    j = gm.ref[:junction][j_junction_idx]

    pi = gm.var[:p][i_junction_idx]
    pj = gm.var[:p][j_junction_idx]

    v = gm.var[:v][valve_idx]

    c1 = @constraint(gm.model,  pj - ((1-v)*j["pmax"]^2) <= pi)
    c2 = @constraint(gm.model,  pi <= pj + ((1-v)*i["pmax"]^2))

    return Set([c1, c2])
end

" constraints on flow across control valves "
function constraint_on_off_control_valve_flow_direction{T}(gm::GenericGasModel{T}, valve_idx)
    valve = gm.ref[:connection][valve_idx]
    i_junction_idx = valve["f_junction"]
    j_junction_idx = valve["t_junction"]

    yp = gm.var[:yp][valve_idx]
    yn = gm.var[:yn][valve_idx]
    f = gm.var[:f][valve_idx]
    v = gm.var[:v][valve_idx]
    max_flow = gm.ref[:max_flow]

    c1 = @constraint(gm.model, -max_flow*(1-yp) <= f)
    c2 = @constraint(gm.model, f <= max_flow*(1-yn))
    c3 = @constraint(gm.model, -max_flow*v <= f )
    c4 = @constraint(gm.model, f <= max_flow*v)

    return Set([c1, c2, c3, c4])
end

" constraints on flow across control valves when directions are constants "
function constraint_on_off_control_valve_flow_direction_fixed_direction{T}(gm::GenericGasModel{T}, valve_idx)
    valve = gm.ref[:connection][valve_idx]
    i_junction_idx = valve["f_junction"]
    j_junction_idx = valve["t_junction"]

    yp = valve["yp"]
    yn = valve["yn"]
    f = gm.var[:f][valve_idx]
    v = gm.var[:v][valve_idx]
    max_flow = gm.ref[:max_flow]

    c1 = @constraint(gm.model, -max_flow*(1-yp) <= f)
    c2 = @constraint(gm.model, f <= max_flow*(1-yn))
    c3 = @constraint(gm.model, -max_flow*v <= f )
    c4 = @constraint(gm.model, f <= max_flow*v)

    return Set([c1, c2, c3, c4])
end

" constraints on pressure drop across control valves "
function constraint_on_off_control_valve_pressure_drop{T}(gm::GenericGasModel{T}, valve_idx)
    valve = gm.ref[:connection][valve_idx]
    i_junction_idx = valve["f_junction"]
    j_junction_idx = valve["t_junction"]

    i = gm.ref[:junction][i_junction_idx]
    j = gm.ref[:junction][j_junction_idx]

    pi = gm.var[:p][i_junction_idx]
    pj = gm.var[:p][j_junction_idx]
    yp = gm.var[:yp][valve_idx]
    yn = gm.var[:yn][valve_idx]
    v = gm.var[:v][valve_idx]

    max_ratio = valve["c_ratio_max"]
    min_ratio = valve["c_ratio_min"]

    c1 = @constraint(gm.model,  pj - (max_ratio*pi) <= (2-yp-v)*j["pmax"]^2)
    c2 = @constraint(gm.model,  (min_ratio*pi) - pj <= (2-yp-v)*(min_ratio*i["pmax"]^2) )
    c3 = @constraint(gm.model,  pi - (max_ratio*pj) <= (2-yn-v)*i["pmax"]^2)
    c4 = @constraint(gm.model,  (min_ratio*pj) - pi <= (2-yn-v)*(min_ratio*j["pmax"]^2))

    return Set([c1, c2, c3, c4])
end

" constraints on pressure drop across control valves when directions are constants "
function constraint_on_off_control_valve_pressure_drop_fixed_direction{T}(gm::GenericGasModel{T}, valve_idx)
    valve = gm.ref[:connection][valve_idx]
    i_junction_idx = valve["f_junction"]
    j_junction_idx = valve["t_junction"]

    i = gm.ref[:junction][i_junction_idx]
    j = gm.ref[:junction][j_junction_idx]

    pi = gm.var[:p][i_junction_idx]
    pj = gm.var[:p][j_junction_idx]
    yp = valve["yp"]
    yn = valve["yn"]
    v = gm.var[:v][valve_idx]

    max_ratio = valve["c_ratio_max"]
    min_ratio = valve["c_ratio_min"]

    c1 = @constraint(gm.model,  pj - (max_ratio*pi) <= (2-yp-v)*j["pmax"]^2)
    c2 = @constraint(gm.model,  (min_ratio*pi) - pj <= (2-yp-v)*(min_ratio*i["pmax"]^2) )
    c3 = @constraint(gm.model,  pi - (max_ratio*pj) <= (2-yn-v)*i["pmax"]^2)
    c4 = @constraint(gm.model,  (min_ratio*pj) - pi <= (2-yn-v)*(min_ratio*j["pmax"]^2))

    return Set([c1, c2, c3, c4])
end

" Make sure there is at least one direction set to take flow away from a junction (typically used on source nodes) "
function constraint_source_flow{T}(gm::GenericGasModel{T}, i)
    f_branches = collect(keys(filter( (a,connection) -> connection["f_junction"] == i, gm.ref[:connection])))
    t_branches = collect(keys(filter( (a,connection) -> connection["t_junction"] == i, gm.ref[:connection])))

    yp = gm.var[:yp]
    yn = gm.var[:yn]

    c = @constraint(gm.model, sum(yp[a] for a in f_branches) + sum(yn[a] for a in t_branches) >= 1)
    return Set([c])
end

" Make sure there is at least one direction set to take flow away from a junction (typically used on source nodes) "
function constraint_source_flow_ne{T}(gm::GenericGasModel{T}, i)
    f_branches = collect(keys(filter( (a,connection) -> connection["f_junction"] == i, gm.ref[:connection])))
    t_branches = collect(keys(filter( (a,connection) -> connection["t_junction"] == i, gm.ref[:connection])))

    f_branches_ne = collect(keys(filter( (a,connection) -> connection["f_junction"] == i, gm.ref[:ne_connection])))
    t_branches_ne = collect(keys(filter( (a,connection) -> connection["t_junction"] == i, gm.ref[:ne_connection])))

    yp = gm.var[:yp]
    yn = gm.var[:yn]

    yp_ne = gm.var[:yp_ne]
    yn_ne = gm.var[:yn_ne]

    c = @constraint(gm.model, sum(yp[a] for a in f_branches) + sum(yn[a] for a in t_branches) + sum(yp_ne[a] for a in f_branches_ne) + sum(yn_ne[a] for a in t_branches_ne) >= 1)
    return Set([c])
end

" Make sure there is at least one direction set to take flow to a junction (typically used on sink nodes) "
function constraint_sink_flow{T}(gm::GenericGasModel{T}, i)
    f_branches = collect(keys(filter( (a,connection) -> connection["f_junction"] == i, gm.ref[:connection])))
    t_branches = collect(keys(filter( (a,connection) -> connection["t_junction"] == i, gm.ref[:connection])))

    yp = gm.var[:yp]
    yn = gm.var[:yn]

    c = @constraint(gm.model, sum(yn[a] for a in f_branches) + sum(yp[a] for a in t_branches) >= 1)
    return Set([c])
end

" Make sure there is at least one direction set to take flow to a junction (typically used on sink nodes) "
function constraint_sink_flow_ne{T}(gm::GenericGasModel{T}, i)
    f_branches = collect(keys(filter( (a,connection) -> connection["f_junction"] == i, gm.ref[:connection])))
    t_branches = collect(keys(filter( (a,connection) -> connection["t_junction"] == i, gm.ref[:connection])))
    f_branches_ne = collect(keys(filter( (a,connection) -> connection["f_junction"] == i, gm.ref[:ne_connection])))
    t_branches_ne = collect(keys(filter( (a,connection) -> connection["t_junction"] == i, gm.ref[:ne_connection])))

    yp = gm.var[:yp]
    yn = gm.var[:yn]
    yp_ne = gm.var[:yp_ne]
    yn_ne = gm.var[:yn_ne]

    c = @constraint(gm.model, sum(yn[a] for a in f_branches) + sum(yp[a] for a in t_branches) + sum(yn_ne[a] for a in f_branches_ne) + sum(yp_ne[a] for a in t_branches_ne) >= 1)
    return Set([c])
end

" This constraint is intended to ensure that flow is on direction through a node with degree 2 and no production or consumption "
function constraint_conserve_flow{T}(gm::GenericGasModel{T}, idx)
    first = nothing
    last = nothing

    for i in gm.ref[:junction_connections][idx]
        connection = gm.ref[:connection][i]
        if connection["f_junction"] == idx
            other = connection["t_junction"]
        else
            other = connection["f_junction"]
        end

        if first == nothing
            first = other
        elseif first != other
            if last != nothing && last != other
                error(string("Error: adding a degree 2 constraint to a node with degree > 2: Junction ", idx))
            end
            last = other
        end
    end

    yp_first = filter(i -> gm.ref[:connection][i]["f_junction"] == first, gm.ref[:junction_connections][idx])
    yn_first = filter(i -> gm.ref[:connection][i]["t_junction"] == first, gm.ref[:junction_connections][idx])
    yp_last  = filter(i -> gm.ref[:connection][i]["t_junction"] == last,  gm.ref[:junction_connections][idx])
    yn_last  = filter(i -> gm.ref[:connection][i]["f_junction"] == last,  gm.ref[:junction_connections][idx])

    yp = gm.var[:yp]
    yn = gm.var[:yn]

    c =  Set([])
    if length(yn_first) > 0 && length(yp_last) > 0
        for i1 in yn_first
            for i2 in yp_last
                c1 = @constraint(gm.model, yn[i1]  == yp[i2])
                c2 = @constraint(gm.model, yp[i1]  == yn[i2])
                c3 = @constraint(gm.model, yn[i1] + yn[i2] == 1)
                c4 = @constraint(gm.model, yp[i1] + yp[i2] == 1)

                union!(c, [c1])
                union!(c, [c2])
                union!(c, [c3])
                union!(c, [c4])
            end
        end
    end


   if length(yn_first) > 0 && length(yn_last) > 0
        for i1 in yn_first
            for i2 in yn_last
                c1 = @constraint(gm.model, yn[i1] == yn[i2])
                c2 = @constraint(gm.model, yp[i1] == yp[i2])
                c3 = @constraint(gm.model, yn[i1] + yp[i2] == 1)
                c4 = @constraint(gm.model, yp[i1] + yn[i2] == 1)

                union!(c, [c1])
                union!(c, [c2])
                union!(c, [c3])
                union!(c, [c4])
            end
        end
    end

    if length(yp_first) > 0 && length(yp_last) > 0
        for i1 in yp_first
            for i2 in yp_last
                c1 = @constraint(gm.model, yp[i1]  == yp[i2])
                c2 = @constraint(gm.model, yn[i1]  == yn[i2])
                c3 = @constraint(gm.model, yp[i1] + yn[i2] == 1)
                c4 = @constraint(gm.model, yn[i1] + yp[i2] == 1)

                union!(c, [c1])
                union!(c, [c2])
                union!(c, [c3])
                union!(c, [c4])
            end
        end
    end

    if length(yp_first) > 0 && length(yn_last) > 0
        for i1 in yp_first
            for i2 in yn_last
                c1 = @constraint(gm.model, yp[i1] == yn[i2])
                c2 = @constraint(gm.model, yn[i1] == yp[i2])
                c3 = @constraint(gm.model, yp[i1] + yp[i2] == 1)
                c4 = @constraint(gm.model, yn[i1] + yn[i2] == 1)

                union!(c, [c1])
                union!(c, [c2])
                union!(c, [c3])
                union!(c, [c4])
            end
        end
    end

    return c
end

function constraint_conserve_flow{T}(gm::GenericGasModel{T}, idx, first, last)
end


" This constraint is intended to ensure that flow is on direction through a node with degree 2 and no production or consumption "
function constraint_conserve_flow_ne{T}(gm::GenericGasModel{T}, idx)
    first = nothing
    last = nothing

    for i in gm.ref[:junction_connections][idx]
        connection = gm.ref[:connection][i]
        if connection["f_junction"] == idx
            other = connection["t_junction"]
        else
            other = connection["f_junction"]
        end

        if first == nothing
            first = other
        elseif first != other
            if last != nothing && last != other
                error(string("Error: adding a degree 2 constraint to a node with degree > 2: Junction ", idx))
            end
            last = other
        end
    end

    for i in gm.ref[:junction_ne_connections][idx]
        connection = gm.ref[:ne_connection][i]
        if connection["f_junction"] == idx
            other = connection["t_junction"]
        else
            other = connection["f_junction"]
        end

        if first == nothing
            first = other
        elseif first != other
            if last != nothing && last != other
                error(string("Error: adding a degree 2 constraint to a node with degree > 2: Junction ", idx))
            end
            last = other
        end
    end


    yp_first = [filter(i -> gm.ref[:connection][i]["f_junction"] == first, gm.ref[:junction_connections][idx]); filter(i -> gm.ref[:ne_connection][i]["f_junction"] == first, gm.ref[:junction_ne_connections][idx])]
    yn_first = [filter(i -> gm.ref[:connection][i]["t_junction"] == first, gm.ref[:junction_connections][idx]); filter(i -> gm.ref[:ne_connection][i]["t_junction"] == first, gm.ref[:junction_ne_connections][idx])]
    yp_last  = [filter(i -> gm.ref[:connection][i]["t_junction"] == last,  gm.ref[:junction_connections][idx]); filter(i -> gm.ref[:ne_connection][i]["t_junction"] == last,  gm.ref[:junction_ne_connections][idx])]
    yn_last  = [filter(i -> gm.ref[:connection][i]["f_junction"] == last,  gm.ref[:junction_connections][idx]); filter(i -> gm.ref[:ne_connection][i]["f_junction"] == last,  gm.ref[:junction_ne_connections][idx])]

    yp = gm.var[:yp]
    yn = gm.var[:yn]
    yp_ne = gm.var[:yp_ne]
    yn_ne = gm.var[:yn_ne]

    c =  Set([])
    if length(yn_first) > 0 && length(yp_last) > 0
        for i1 in yn_first
            for i2 in yp_last
                yn1 = haskey(gm.ref[:connection],i1) ? yn[i1] : yn_ne[i1]
                yn2 = haskey(gm.ref[:connection],i2) ? yn[i2] : yn_ne[i2]
                yp1 = haskey(gm.ref[:connection],i1) ? yp[i1] : yp_ne[i1]
                yp2 = haskey(gm.ref[:connection],i2) ? yp[i2] : yp_ne[i2]

                c1 = @constraint(gm.model, yn1  == yp2)
                c2 = @constraint(gm.model, yp1  == yn2)
                c3 = @constraint(gm.model, yn1 + yn2 == 1)
                c4 = @constraint(gm.model, yp1 + yp2 == 1)

                union!(c, [c1])
                union!(c, [c2])
                union!(c, [c3])
                union!(c, [c4])
            end
        end
    end

    if length(yn_first) > 0 && length(yn_last) > 0
        for i1 in yn_first
            for i2 in yn_last
                yn1 = haskey(gm.ref[:connection],i1) ? yn[i1] : yn_ne[i1]
                yn2 = haskey(gm.ref[:connection],i2) ? yn[i2] : yn_ne[i2]
                yp1 = haskey(gm.ref[:connection],i1) ? yp[i1] : yp_ne[i1]
                yp2 = haskey(gm.ref[:connection],i2) ? yp[i2] : yp_ne[i2]

                c1 = @constraint(gm.model, yn1 == yn2)
                c2 = @constraint(gm.model, yp1 == yp2)
                c3 = @constraint(gm.model, yn1 + yp2 == 1)
                c4 = @constraint(gm.model, yp1 + yn2 == 1)

                union!(c, [c1])
                union!(c, [c2])
                union!(c, [c3])
                union!(c, [c4])
            end
        end
    end

    if length(yp_first) > 0 && length(yp_last) > 0
        for i1 in yp_first
            for i2 in yp_last
                yn1 = haskey(gm.ref[:connection],i1) ? yn[i1] : yn_ne[i1]
                yn2 = haskey(gm.ref[:connection],i2) ? yn[i2] : yn_ne[i2]
                yp1 = haskey(gm.ref[:connection],i1) ? yp[i1] : yp_ne[i1]
                yp2 = haskey(gm.ref[:connection],i2) ? yp[i2] : yp_ne[i2]

                c1 = @constraint(gm.model, yp1 == yp2)
                c2 = @constraint(gm.model, yn1 == yn2)
                c3 = @constraint(gm.model, yp1 + yn2 == 1)
                c4 = @constraint(gm.model, yn1 + yp2 == 1)

                union!(c, [c1])
                union!(c, [c2])
                union!(c, [c3])
                union!(c, [c4])
            end
        end
    end

    if length(yp_first) > 0 && length(yn_last) > 0
        for i1 in yp_first
            for i2 in yn_last
                yn1 = haskey(gm.ref[:connection],i1) ? yn[i1] : yn_ne[i1]
                yn2 = haskey(gm.ref[:connection],i2) ? yn[i2] : yn_ne[i2]
                yp1 = haskey(gm.ref[:connection],i1) ? yp[i1] : yp_ne[i1]
                yp2 = haskey(gm.ref[:connection],i2) ? yp[i2] : yp_ne[i2]

                c1 = @constraint(gm.model, yp1 == yn2)
                c2 = @constraint(gm.model, yn1 == yp2)
                c3 = @constraint(gm.model, yp1 + yp2 == 1)
                c4 = @constraint(gm.model, yn1 + yn2 == 1)

                union!(c, [c1])
                union!(c, [c2])
                union!(c, [c3])
                union!(c, [c4])
            end
        end
    end

    return c
end

" ensures that parallel lines have flow in the same direction "
function constraint_parallel_flow{T}(gm::GenericGasModel{T}, idx)
    connection = gm.ref[:connection][idx]
    i = min(connection["f_junction"], connection["t_junction"])
    j = max(connection["f_junction"], connection["t_junction"])

    f_connections = filter(i -> gm.ref[:connection][i]["f_junction"] == connection["f_junction"], gm.ref[:parallel_connections][(i,j)])
    t_connections = filter(i -> gm.ref[:connection][i]["f_junction"] != connection["f_junction"], gm.ref[:parallel_connections][(i,j)])

    yp = gm.var[:yp]
    yn = gm.var[:yn]

    if length(gm.ref[:parallel_connections][(i,j)]) <= 1
        return nothing
    end

    c = @constraint(gm.model, sum(yp[i] for i in f_connections) + sum(yn[i] for i in t_connections) == yp[idx] * length(gm.ref[:parallel_connections][(i,j)]))
    return Set([c])
end

" ensures that parallel lines have flow in the same direction "
function constraint_parallel_flow_ne{T}(gm::GenericGasModel{T}, idx)
    connection = haskey(gm.ref[:connection], idx) ? gm.ref[:connection][idx] : gm.ref[:ne_connection][idx]

    i = min(connection["f_junction"], connection["t_junction"])
    j = max(connection["f_junction"], connection["t_junction"])

    f_connections = filter(i -> gm.ref[:connection][i]["f_junction"] == connection["f_junction"], intersect(gm.ref[:all_parallel_connections][(i,j)], gm.ref[:parallel_connections][(i,j)]))
    t_connections = filter(i -> gm.ref[:connection][i]["f_junction"] != connection["f_junction"], intersect(gm.ref[:all_parallel_connections][(i,j)], gm.ref[:parallel_connections][(i,j)]))
    f_connections_ne = filter(i -> gm.ref[:ne_connection][i]["f_junction"] == connection["f_junction"], setdiff(gm.ref[:all_parallel_connections][(i,j)], gm.ref[:parallel_connections][(i,j)]))
    t_connections_ne = filter(i -> gm.ref[:ne_connection][i]["f_junction"] != connection["f_junction"], setdiff(gm.ref[:all_parallel_connections][(i,j)], gm.ref[:parallel_connections][(i,j)]))

    yp = gm.var[:yp]
    yn = gm.var[:yn]
    yp_ne = gm.var[:yp_ne]
    yn_ne = gm.var[:yn_ne]
    yp_i = haskey(gm.ref[:connection], idx) ? yp[idx] : yp_ne[idx]

    if length(gm.ref[:all_parallel_connections][(i,j)]) <= 1
        return nothing
    end

    c = @constraint(gm.model, sum(yp[i] for i in f_connections) + sum(yn[i] for i in t_connections) + sum(yp_ne[i] for i in f_connections_ne) + sum(yn_ne[i] for i in t_connections_ne) == yp_i * length(gm.ref[:all_parallel_connections][(i,j)]))
    return Set([c])
end
