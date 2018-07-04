#!/bin/bash

set -e

update-ca-certificates

exec ruby authorize.rb "$@"
