const config = {
  name: 'ex-traQ',
  firebase: {
    apiKey: 'AIzaSyC6NjeT0DPaAM3pBvAfKEm2PHig43QNHus',
    appId: '1:1078290191738:web:f21fdcfe8ced32f5cbb2c3',
    projectId: 'ex-trap',
    messagingSenderId: '1078290191738'
  },
  skyway: {
    apiKey: 'cf01c6ad-3673-4b9e-aa5e-b9f8172ef704'
  },
  services: [
    {
      label: 'Official Website',
      iconPath: 'traP.svg',
      appLink: 'https://trap.jp/'
    },
    {
      label: 'ex-traP Wiki',
      iconPath: 'growi.svg',
      appLink: 'https://wiki.ex.trap.jp/'
    },
  ],
  ogpIgnoreHostNames: [
    'wiki.ex.trap.jp',
  ],
  wikiPageOrigin: 'https://wiki.ex.trap.jp/',
  auth: {
    resetLink: undefined,
    changeLink: undefined,
    changeName: undefined
  },
  pipelineEnabled: false,
  isRootChannelSelectableAsParentChannel: true,
  showQrCodeButton: false,
  tooLargeFileMessage: '大きい%sの共有にはDriveを使用してください',
  showWidgetCopyButton: false,
  inlineReplyDisableChannels: ['#general']
}

self.traQConfig = config
