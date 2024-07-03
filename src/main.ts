import { createApp, defineAsyncComponent } from "vue";
import { createPinia } from "pinia";
import { ref } from 'vue';
import { createI18n } from "vue-i18n";
import VueConnectWallet from "vue-connect-wallet";
import messages from "@intlify/unplugin-vue-i18n/messages";
import { definePreset } from "@primevue/themes";
import Loader from "./Loader.vue";
import { useMetaMaskWallet } from "vue-connect-wallet";


import "./assets/reset.scss";
import "primeicons/primeicons.css";
import "vue-connect-wallet/dist/style.css";

import PrimeVue from "primevue/config";
import Aura from "@primevue/themes/aura";

const Theme = definePreset(Aura, {
  components: {
    button: {
      colorScheme: {
        light: {
          secondary: {
            hoverBackground: "{surface.0}",
            activeBackground: "{surface.0}",
            hoverBorderColor: "{surface.0}",
            activeBorderColor: "{surface.0}",
          },
        },
      },
    },
  },
});

const AsyncApp = defineAsyncComponent({
  loader: () => import("./App.vue"),
  loadingComponent: Loader,
});

const app = createApp(AsyncApp);

app.use(createPinia());
app.use(VueConnectWallet);
app.use(
  createI18n({
    legacy: false,
    locale: navigator.language.split("-")[0],
    fallbackLocale: "en",
    messages,
  })
);
app.use(PrimeVue, {
  theme: {
    preset: Theme,
    options: {
      darkModeSelector: ".dark",
    },
  },
});


const address = ref("");
const wallet = useMetaMaskWallet();

wallet.onAccountsChanged((accounts: string[]) => {
  console.log("account changed to: ", accounts[0]);
});
wallet.onChainChanged((chainId: number) => {
  console.log("chain changed to:", chainId);
});

const connect = async () => {
  const accounts = await wallet.connect();
  if (typeof accounts === "string") {
    console.log("An error occurred" + accounts);
  }
  address.value = accounts[0];
};

const switchAccount = async () => {
  await wallet.switchAccounts();
  connect();
};

const isConnected = async () => {
  const accounts = await wallet.getAccounts();
  if (typeof accounts === "string") return false;
  return accounts.length > 0;
};

app.mount("#app");
