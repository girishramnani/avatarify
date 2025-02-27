<script setup lang="ts">
import { useI18n } from 'vue-i18n';
import useMainStore from '@/stores/main';
import getRandomOptions from '@/utils/getRandomOptions';
import availableStyles from '@/config/styles';
import getApiUrl from '@/utils/getApiUrl';
import { computed, ref } from 'vue';
import { useFullscreen } from '@vueuse/core';
import { ConnectWalletButton } from "vue-connect-wallet";
import { useMetaMaskWallet } from "vue-connect-wallet";

const address = ref("");
const wallet = useMetaMaskWallet();

const { t } = useI18n();
const store = useMainStore();
const show = ref(false);
const { isFullscreen, enter } = useFullscreen();

const styleMeta = computed(
  () => availableStyles[store.selectedStyleName].style.meta
);

function onShuffle() {
  store.selectedStyleOptions = getRandomOptions(
    availableStyles[store.selectedStyleName].options
  );
}

async function onDownload() {
  show.value = true;

  const apiUrl = getApiUrl(
    store.selectedStyleName,
    store.selectedStyleOptions,
    'png'
  );

  const response = await fetch(apiUrl);
  const blob = await response.blob();
  const file = URL.createObjectURL(blob);
  const timestamp = new Date().getTime();

  const link = document.createElement('a');
  link.href = file;
  link.download = `${store.selectedStyleName}-${timestamp}.png`;
  link.target = '_blank';
  link.click();
  link.remove();

  URL.revokeObjectURL(file);
}

async function onConnect() {
  await wallet.switchAccounts();
  const accounts = await wallet.connect();

  console.log("here");
  if (typeof accounts === "string") {
    console.log("An error occurred" + accounts);
  }
  console.log(accounts);
  address.value = accounts[0].trim();
}

function onFullscreen() {
  enter();
}

</script>

<template>
  <Dialog
    v-model:visible="show"
    modal
    :draggable="false"
    :header="t('downloadStarted')"
    :style="{ maxWidth: '400px' }"
  >
    <p class="header-dialog-text">{{ t('downloadStartedDescription') }}</p>
    <p
      v-if="styleMeta?.license?.name !== 'CC0 1.0'"
      class="header-dialog-text"
      v-html="
        t('downloadStartedDescriptionLicense', {
          title: styleMeta?.title,
          source: styleMeta?.source,
          creator: styleMeta?.creator,
          homepage: styleMeta?.homepage,
          licenseName: styleMeta?.license?.name,
          licenseUrl: styleMeta?.license?.url,
        })
      "
    ></p>
  </Dialog>

  <div class="header">
    <div class="header-actions">
      <Button
        icon="pi pi-sparkles"
        severity="secondary"
        rounded
        :aria-label="t('shuffle')"
        @click="onShuffle"
      />
      <Button
        v-if="!isFullscreen"
        icon="pi pi-window-maximize"
        severity="secondary"
        rounded
        :aria-label="t('shuffle')"
        @click="onFullscreen"
      />
    </div>
    <Button
      rounded
      severity="secondary"
      :label="t('Mint')"
      @click="onDownload"
    />

    <ConnectWalletButton @click="onConnect" address="address"/>
  </div>
</template>

<style lang="scss">
.header {
  display: flex;
  justify-content: space-between;
  padding-top: 16px;

  &-actions {
    display: flex;
    gap: 8px;
  }

  &-dialog-text {
    text-align: center;
    font-size: 14px;
    margin: 16px 12px;
  }
}
</style>
