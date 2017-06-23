-module(eflame_wrapper).

%% API exports
-export([main/1]).

%%====================================================================
%% API functions
%%====================================================================

%% escript Entry point
main(Args) ->
    io:format("Args: ~p~n", [Args]),
    RemoteNode = list_to_atom(os:getenv("ERL_REMOTE_NODE")),
    io:format("Remote Node: ~p~n", [RemoteNode]),
    Result = safe_rpc(RemoteNode, io, format, ["hello from the other side~n"]),
    io:format("Result: ~p~n", [Result]),
    erlang:halt(0).

%%====================================================================
%% Internal functions
%%====================================================================

-spec safe_rpc(node(), module(), atom(), [term()]) -> {error, term()} | term().
safe_rpc(N, M, F, A) ->
    safe_rpc(N, M, F, A, 10000).

-spec safe_rpc(node(), module(), atom(), [term()], timeout()) -> {error, term()} | term().
safe_rpc(N, M, F, A, Timeout) ->
    Result = try rpc:call(N, M, F, A, Timeout) of
                 R ->
                     R
             catch
                 'EXIT':{noproc, _NoProcDetails} ->
                     {badrpc, rpc_process_down};
                 'EXIT':{timeout, _} ->
                     {badrpc, timeout}
             end,
    case Result of
        {badrpc, Reason} -> {error, Reason};
        _ -> Result
    end.
