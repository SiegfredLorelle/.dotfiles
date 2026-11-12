#!/usr/bin/env bash
# Claude Code status line: model, current context size in tokens, and plan usage.

jq -r '
    def tokens: if . >= 999500 then "\((. / 100000 | round) / 10)M"
        elif . >= 1000 then "\(. / 1000 | round)k"
        else tostring end;
    def window($label): select(. != null) | "\($label) \(.used_percentage | round)%";
    (.context_window.current_usage // {}) as $u
    | [
        .model.display_name,
        (($u.input_tokens // 0) + ($u.cache_creation_input_tokens // 0) + ($u.cache_read_input_tokens // 0) | tokens),
        (.rate_limits.five_hour | window("5h")),
        (.rate_limits.seven_day | window("7d"))
      ]
    | map(select(. != null)) | join(" · ")
'
