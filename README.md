# transfer_file
Transfer or copy file between erlang nodes.

# Usage

```bash
rebar3 compile
```

# Example

```erlang
1> c(transfer_file_app).
{ok, transfer_file_app}
2> Pid0 = transfer_file_app:start('remote@computer').
<12472.95.0>
3> transfer_file_app:rpc(Pid0, file, list_dir, ["."]).
{ok, ["transfer_file_app.beam", "transfer_file_app.erl"]}
4> transfer_file_app:get_file(Pid0, "transfer_file_app.erl").
ok
```
