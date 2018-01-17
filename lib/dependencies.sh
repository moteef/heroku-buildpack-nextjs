run_if_present() {
  local script_name=${1:-}
  local has_script=$(read_json "$APP_DIR/package.json" ".scripts[\"$script_name\"]")
  if [ -n "$has_script" ]; then
    echo "Running $script_name"
    yarn "$script_name"
  fi
}

install_node_modules() {
  local build_dir=${1:-}

  if [ -e $build_dir/package.json ]; then
    cd $build_dir

    if [ -e $build_dir/yarn.lock ]; then
      echo "Installing node modules (package.json + yarn.lock)"
    else
      echo "Installing node modules (package.json)"
    fi
    yarn 2>&1
  else
    echo "Skipping (no package.json)"
  fi
}

rebuild_node_modules() {
  local build_dir=${1:-}

  if [ -e $build_dir/package.json ]; then
    cd $build_dir
    echo "Rebuilding any native modules"
    yarn install --force 2>&1
    if [ -e $build_dir/yarn.lock ]; then
      echo "Installing any new modules (package.json + yarn.lock)"
    else
      echo "Installing any new modules (package.json)"
    fi
    yarn 2>&1
  else
    echo "Skipping (no package.json)"
  fi
}
