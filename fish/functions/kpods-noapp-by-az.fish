function kpods-noapp-by-az --description 'List pods (excluding component=app) with node and AZ'
    set -l pods (mktemp)
    set -l nodes (mktemp)
    kubectl get pods -A -l 'component!=app' -o json > $pods
    kubectl get nodes -o json > $nodes
    jq -r -s '
           def zonemap:
             (.[1].items
               | map({key: .metadata.name, value: .metadata.labels["topology.kubernetes.io/zone"]})
               | from_entries);
           (.[0].items[] | {ns: .metadata.namespace, name: .metadata.name, node: .spec.nodeName}) as $p
           | [$p.ns, $p.name, $p.node, (zonemap[$p.node] // "n/a")] | @tsv
         ' $pods $nodes | column -t
    rm -f $pods $nodes
end
