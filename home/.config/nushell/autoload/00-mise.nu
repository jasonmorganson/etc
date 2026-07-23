def "parse mise vars" [] {
  $in | from csv --noheaders --no-infer | rename op name value
}

def --env "apply mise vars" [] {
  for var in $in {
    if $var.op == "set" {
      if ($var.name =~ '(?i)^path$') {
        $env.PATH = ($var.value | split row (char esep))
      } else {
        load-env {($var.name): $var.value}
      }
    } else if $var.op == "hide" and $var.name in $env {
      hide-env $var.name
    }
  }
}

def --env "add mise hook" [field: cell-path new_hook: any] {
  let field = $field | split cell-path | update optional true | into cell-path
  let old_config = $env.config? | default {}
  let old_hooks = $old_config | get $field | default []
  $env.config = ($old_config | upsert $field ($old_hooks ++ [$new_hook]))
}

def --env mise_hook [] {
  ^mise hook-env -s nu
    | parse mise vars
    | apply mise vars
}

$env.PATH = ($env.PATH | prepend ($env.HOME | path join ".local" "bin"))
$env.MISE_SHELL = "nu"

let mise_hook = {
  condition: { "MISE_SHELL" in $env }
  code: { mise_hook }
}

add mise hook hooks.pre_prompt $mise_hook
add mise hook hooks.env_change.PWD $mise_hook
mise_hook

export def --env --wrapped mise [command?: string, --help, ...rest: string] {
  let commands = ["deactivate", "shell", "sh"]

  if ($command == null) {
    ^mise
  } else if ($command == "activate") {
    $env.MISE_SHELL = "nu"
  } else if ($command in $commands) {
    ^mise $command ...$rest
      | parse mise vars
      | apply mise vars
  } else {
    ^mise $command ...$rest
  }
}
