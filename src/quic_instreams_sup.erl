-module(quic_instreams_sup).
-behaviour(supervisor).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/0]).
-export([start_instream/4]).

%% ------------------------------------------------------------------
%% supervisor Function Exports
%% ------------------------------------------------------------------

-export([init/1]).

%% ------------------------------------------------------------------
%% Macro Definitions
%% ------------------------------------------------------------------

-define(CHILD(I, Type), {I, {I, start_link, []}, temporary, 5000, Type, [I]}).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link() ->
    supervisor:start_link(?MODULE, []).

start_instream(SupervisorPid, StreamId, StreamHandler, StreamHandlerPid) ->
    supervisor:start_child(SupervisorPid, [StreamId, StreamHandler, StreamHandlerPid]).

%% ------------------------------------------------------------------
%% supervisor Function Definitions
%% ------------------------------------------------------------------

init([]) ->
    StreamChild = ?CHILD(quic_instream, worker),
    {ok, {{simple_one_for_one, 10, 1}, [StreamChild]}}.
