import canister from "ic:canisters/backend";
import Vue from "vue";


const store = Vue.observable({
    hello: null,
});

const getActions = {

}

const createActions = {
    
}

Vue.prototype.$store = store
Vue.prototype.$getActions = getActions
Vue.prototype.$createActions = createActions