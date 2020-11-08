#!/bin/bash
info () {
bundleDu="$(du -h /root/deploy/bundle/koffer-bundle.collector-operators.tar | awk '{print $1}' | head -n 1)"
bundlePath="$(ls /root/deploy/bundle/koffer-bundle.collector-operators.tar | head -n 1 | sed 's/root\/deploy/tmp\/platform/')"
cat <<EOF

  Koffer Bundle Complete: ${bundleDu} ${bundlePath}

  Next Steps:
    - Move to cloudctl deployment services bastion \`/tmp\`
    - Unpack bundle into image registry path via cmd:

        \`tar xv -f /tmp/koffer-bundle.collector-operators.tar -C /root/deploy\`

    - Apply operators to cluster with configs in \`mirror/config/operators/\`

EOF
}
info
