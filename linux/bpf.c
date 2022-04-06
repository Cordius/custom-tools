#include <linux/bpf.h>
  #include <linux/pkt_cls.h>
  #include <linux/types.h>
  #include <bpf/bpf_helpers.h>

  struct {
          __uint(type, BPF_MAP_TYPE_HASH);
          __uint(max_entries, 1);
          __type(key, int);                                                                                                                                                                                                __type(value, int);
  } hmap SEC(".maps");

  //struct bpf_map_def SEC("maps") hmap = {
  //          .type        = BPF_MAP_TYPE_HASH,
  //              .key_size    = sizeof(int),
  //                  .value_size  = sizeof(int),
  //                      .max_entries = 1,
  //};

  SEC("classifier")
  int _classifier(struct __sk_buff *skb)
  {
          int key = 0;
          int *val;

          val = bpf_map_lookup_elem(&hmap, &key);
          if (!val)
                  return TC_ACT_OK;
          return TC_ACT_OK;
  }

  char __license[] SEC("license") = "GPL";
