%% app generated at {2015,6,22} {21,57,27}
{application,ranch,
             [{description,"Socket acceptor pool for TCP protocols."},
              {vsn,"0.8.4"},
              {id,"Ranch"},
              {modules,[ranch,ranch_acceptor,ranch_acceptors_sup,ranch_app,
                        ranch_conns_sup,ranch_listener_sup,ranch_protocol,
                        ranch_server,ranch_ssl,ranch_sup,ranch_tcp,
                        ranch_transport]},
              {registered,[ranch_sup,ranch_server]},
              {applications,[kernel,stdlib]},
              {included_applications,[]},
              {env,[]},
              {maxT,infinity},
              {maxP,infinity},
              {mod,{ranch_app,[]}}]}.

