<template>
  <div>
    <section>
      <canvas width="1000" height="1000" id="c"></canvas>
    </section>
  </div>
</template>

<style scoped>
</style>

<script>
import canister from "ic:canisters/backend";

export default {
  components: {},
  data() {
    return {
      vueCanvas: undefined,
    };
  },
  computed: {},
  watch: {},
  methods: {},
  mounted() {
    console.log("Hello Worl");
    var c = document.getElementById("c");
    var ctx = c.getContext("2d");
    this.vueCanvas = ctx;
    console.log(ctx);
    canister.getMap().then((v) => {
      console.log(v)
      for (let pt = 0; pt < v.length - 3; pt += 3) {
        let here = pt / 3;
        let x = Math.floor(here / 1000);
        let y = here % 1000
        ctx.fillStyle = `rgba(${v[pt]}, ${v[pt+1]}, ${v[pt+2]}, 1)`;
        ctx.fillRect(x, y, 1, 1);
      }
    });
  },
};
</script>