Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbZDUQwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbZDUQwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbZDUQvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:51:51 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44471 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbZDUQvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:51:45 -0400
Subject: [BUILD FAILURE 01/04] Next April 21 : x86_64 randconfig
	[drivers/staging/rt3070/built-in.o]
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next <linux-next@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Alessio Igor Bogani <abogani@texware.it>
Content-Type: multipart/mixed; boundary="=-hEItHhQn+Q//sZ7yOLX/"
Organization: IBM
Date: Tue, 21 Apr 2009 22:21:24 +0530
Message-Id: <1240332685.9110.37.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hEItHhQn+Q//sZ7yOLX/
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Observed the Following error:

drivers/staging/rt3070/built-in.o: In function `CntlOidSsidProc':
(.text+0x48c29): multiple definition of `CntlOidSsidProc'
drivers/staging/rt2870/built-in.o:(.text+0x44ce5): first defined here
drivers/staging/rt3070/built-in.o: In function
`RTMPCheckEntryEnableAutoRateSwitch':
(.text+0x3c31): multiple definition of
`RTMPCheckEntryEnableAutoRateSwitch'
drivers/staging/rt2870/built-in.o:(.text+0x3c63): first defined here
drivers/staging/rt3070/built-in.o: In function `RT2870_TimerQ_Init':
(.text+0x6c3c7): multiple definition of `RT2870_TimerQ_Init'
drivers/staging/rt2870/built-in.o:(.text+0x68452): first defined here
drivers/staging/rt3070/built-in.o: In function `RTMPCheckDHCPFrame':
(.text+0x1622d): multiple definition of `RTMPCheckDHCPFrame'
drivers/staging/rt2870/built-in.o:(.text+0x155c5): first defined here
drivers/staging/rt3070/built-in.o: In function
`BARecSessionIdleTimeout':
(.text+0x694cc): multiple definition of `BARecSessionIdleTimeout'
drivers/staging/rt2870/built-in.o:(.text+0x654fc): first defined here
drivers/staging/rt3070/built-in.o: In function `RTUSBFirmwareRun':
(.text+0x727af): multiple definition of `RTUSBFirmwareRun'
drivers/staging/rt2870/built-in.o:(.text+0x6ebee): first defined here
drivers/staging/rt3070/built-in.o: In function
`RTMPBbpReadRadarDuration':
(.text+0x30ff4): multiple definition of `RTMPBbpReadRadarDuration'
drivers/staging/rt2870/built-in.o:(.text+0x2d12c): first defined here
drivers/staging/rt3070/built-in.o: In function `RTMPCheckRSNIE':
(.text+0x2f2ec): multiple definition of `RTMPCheckRSNIE'
drivers/staging/rt2870/built-in.o:(.text+0x2b424): first defined here
drivers/staging/rt3070/built-in.o: In function `LinkDown':
(.text+0x45207): multiple definition of `LinkDown'
drivers/staging/rt2870/built-in.o:(.text+0x4140f): first defined here
drivers/staging/rt3070/built-in.o: In function `MlmeUpdateHtTxRates':
(.text+0x4eed): multiple definition of `MlmeUpdateHtTxRates'
drivers/staging/rt2870/built-in.o:(.text+0x5067): first defined here
drivers/staging/rt3070/built-in.o: In function `RTUSBPutToSleep':
(.text+0x71fa2): multiple definition of `RTUSBPutToSleep'
drivers/staging/rt2870/built-in.o:(.text+0x6e10a): first defined here
drivers/staging/rt3070/built-in.o: In function `AES_GTK_KEY_UNWRAP':
(.text+0x2f91b): multiple definition of `AES_GTK_KEY_UNWRAP'
drivers/staging/rt2870/built-in.o:(.text+0x2ba53): first defined here
drivers/staging/rt3070/built-in.o: In function `NetworkTypeInUseSanity':
(.text+0x25d08): multiple definition of `NetworkTypeInUseSanity'
drivers/staging/rt2870/built-in.o:(.text+0x21d0c): first defined here
drivers/staging/rt3070/built-in.o: In function `rt_ioctl_iwaplist':
(.text+0x59554): multiple definition of `rt_ioctl_iwaplist'
drivers/staging/rt2870/built-in.o:(.text+0x55847): first defined here
drivers/staging/rt3070/built-in.o: In function `PeerHTAction':
(.text+0x13da8): multiple definition of `PeerHTAction'
drivers/staging/rt2870/built-in.o:(.text+0x13140): first defined here
drivers/staging/rt3070/built-in.o: In function `NoiseHistReportAction':
(.text+0x3840e): multiple definition of `NoiseHistReportAction'
drivers/staging/rt2870/built-in.o:(.text+0x345b2): first defined here
drivers/staging/rt3070/built-in.o: In function `BATableFreeOriEntry':
(.text+0x672d7): multiple definition of `BATableFreeOriEntry'
drivers/staging/rt2870/built-in.o:(.text+0x63517): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x3fb0): multiple definition of
`SboxTable'
drivers/staging/rt2870/built-in.o:(.data+0x3fb0): first defined here
drivers/staging/rt3070/built-in.o: In function `rt28xx_probe':
(.devinit.text+0x0): multiple definition of `rt28xx_probe'
drivers/staging/rt2870/built-in.o:(.devinit.text+0x0): first defined
here
drivers/staging/rt3070/built-in.o: In function `PeerSpectrumAction':
(.text+0x325bb): multiple definition of `PeerSpectrumAction'
drivers/staging/rt2870/built-in.o:(.text+0x2e6f3): first defined here
drivers/staging/rt3070/built-in.o: In function `ScanTimeout':
(.text+0x3f342): multiple definition of `ScanTimeout'
drivers/staging/rt2870/built-in.o:(.text+0x3b6a4): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x562): multiple definition of
`DsIe'
drivers/staging/rt2870/built-in.o:(.data+0x562): first defined here
drivers/staging/rt3070/built-in.o: In function `ApRadarDetectPeriodic':
(.text+0x3127a): multiple definition of `ApRadarDetectPeriodic'
drivers/staging/rt2870/built-in.o:(.text+0x2d3b2): first defined here
drivers/staging/rt3070/built-in.o: In function `MlmeAssocReqSanity':
(.text+0x26b1f): multiple definition of `MlmeAssocReqSanity'
drivers/staging/rt2870/built-in.o:(.text+0x22b23): first defined here
drivers/staging/rt3070/built-in.o: In function `RTUSBSingleWrite':
(.text+0x70714): multiple definition of `RTUSBSingleWrite'
drivers/staging/rt2870/built-in.o:(.text+0x6c992): first defined here
drivers/staging/rt3070/built-in.o: In function `MakeOutgoingFrame':
(.text+0xfffc): multiple definition of `MakeOutgoingFrame'
drivers/staging/rt2870/built-in.o:(.text+0xf3d6): first defined here
drivers/staging/rt3070/built-in.o: In function `RTMPTkipGetUInt32':
(.text+0x1ffdc): multiple definition of `RTMPTkipGetUInt32'
drivers/staging/rt2870/built-in.o:(.text+0x1e380): first defined here
drivers/staging/rt3070/built-in.o: In function `ComposePsPoll':
(.text+0x449ec): multiple definition of `ComposePsPoll'
drivers/staging/rt2870/built-in.o:(.text+0x40bf4): first defined here
drivers/staging/rt3070/built-in.o: In function `AsicUpdateWCIDIVEIV':
(.text+0x68c8): multiple definition of `AsicUpdateWCIDIVEIV'
drivers/staging/rt2870/built-in.o:(.text+0x6794): first defined here
drivers/staging/rt3070/built-in.o: In function `Set_BASetup_Proc':
(.text+0x2a805): multiple definition of `Set_BASetup_Proc'
drivers/staging/rt2870/built-in.o:(.text+0x2682b): first defined here
drivers/staging/rt3070/built-in.o: In function `Set_HtMimoPs_Proc':
(.text+0x2945b): multiple definition of `Set_HtMimoPs_Proc'
drivers/staging/rt2870/built-in.o:(.text+0x25481): first defined here
drivers/staging/rt3070/built-in.o: In function `rt_ioctl_siwpmksa':
(.text+0x60c7d): multiple definition of `rt_ioctl_siwpmksa'
drivers/staging/rt2870/built-in.o:(.text+0x5d85e): first defined here
drivers/staging/rt3070/built-in.o: In function
`BA_Reorder_AMSDU_Annnounce':
(.text+0x17a4b): multiple definition of `BA_Reorder_AMSDU_Annnounce'
drivers/staging/rt2870/built-in.o:(.text+0x16df5): first defined here
drivers/staging/rt3070/built-in.o: In function `ScanParmFill':
(.text+0x44795): multiple definition of `ScanParmFill'
drivers/staging/rt2870/built-in.o:(.text+0x4099d): first defined here
drivers/staging/rt3070/built-in.o: In function `RTMP_OS_Init_Timer':
(.text+0x4f4c8): multiple definition of `RTMP_OS_Init_Timer'
drivers/staging/rt2870/built-in.o:(.text+0x4b65c): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x43c4): multiple definition of
`OUI_WPA2_8021X_AKM'
drivers/staging/rt2870/built-in.o:(.data+0x43cc): first defined here
drivers/staging/rt3070/built-in.o: In function `RTMPusecDelay':
(.text+0x4f2ad): multiple definition of `RTMPusecDelay'
drivers/staging/rt2870/built-in.o:(.text+0x4b441): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x13f4): multiple definition of
`default_sta_aifsn'
drivers/staging/rt2870/built-in.o:(.data+0x13f4): first defined here
drivers/staging/rt3070/built-in.o: In function `update_os_packet_info':
(.text+0x4d5b1): multiple definition of `update_os_packet_info'
drivers/staging/rt2870/built-in.o:(.text+0x49745): first defined here
drivers/staging/rt3070/built-in.o: In function `IterateOnBssTab2':
(.text+0x44f9d): multiple definition of `IterateOnBssTab2'
drivers/staging/rt2870/built-in.o:(.text+0x411a5): first defined here
drivers/staging/rt3070/built-in.o: In function `MlmeDELBAAction':
(.text+0x141bd): multiple definition of `MlmeDELBAAction'
drivers/staging/rt2870/built-in.o:(.text+0x13555): first defined here
drivers/staging/rt3070/built-in.o: In function `GetTimBit':
(.text+0x3f664): multiple definition of `GetTimBit'
drivers/staging/rt2870/built-in.o:(.text+0x3ba34): first defined here
drivers/staging/rt3070/built-in.o: In function `PeerProbeReqAction':
(.text+0x3b92e): multiple definition of `PeerProbeReqAction'
drivers/staging/rt2870/built-in.o:(.text+0x37c9e): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x530): multiple definition of
`RateIdToMbps'
drivers/staging/rt2870/built-in.o:(.data+0x530): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x55f): multiple definition of
`AddHtInfoIe'
drivers/staging/rt2870/built-in.o:(.data+0x55f): first defined here
drivers/staging/rt3070/built-in.o: In function `Show_DescInfo_Proc':
(.text+0x27eb4): multiple definition of `Show_DescInfo_Proc'
drivers/staging/rt2870/built-in.o:(.text+0x23eb8): first defined here
drivers/staging/rt3070/built-in.o: In function
`STABuildCommon802_11Header':
(.text+0x404cd): multiple definition of `STABuildCommon802_11Header'
drivers/staging/rt2870/built-in.o:(.text+0x3c89d): first defined here
drivers/staging/rt3070/built-in.o: In function `aes128k128d':
(.text+0x20779): multiple definition of `aes128k128d'
drivers/staging/rt2870/built-in.o:(.text+0x1eb1d): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x40c0): multiple definition of
`A_BAND_REGION_1_CHANNEL_LIST'
drivers/staging/rt2870/built-in.o:(.data+0x40c0): first defined here
drivers/staging/rt3070/built-in.o: In function `MlmeSetTxRate':
(.text+0xc30e): multiple definition of `MlmeSetTxRate'
drivers/staging/rt2870/built-in.o:(.text+0xb4de): first defined here
drivers/staging/rt3070/built-in.o: In function `AsicEnableRDG':
(.text+0x6efb): multiple definition of `AsicEnableRDG'
drivers/staging/rt2870/built-in.o:(.text+0x6e11): first defined here
drivers/staging/rt3070/built-in.o: In function `STASendPacket':
(.text+0x424dc): multiple definition of `STASendPacket'
drivers/staging/rt2870/built-in.o:(.text+0x3e8ac): first defined here
drivers/staging/rt3070/built-in.o: In function `RT2870_WatchDog':
(.text+0x6bc95): multiple definition of `RT2870_WatchDog'
drivers/staging/rt2870/built-in.o:(.text+0x67d20): first defined here
drivers/staging/rt3070/built-in.o: In function `PeerWpaMessageSanity':
(.text+0x263c5): multiple definition of `PeerWpaMessageSanity'
drivers/staging/rt2870/built-in.o:(.text+0x223c9): first defined here
drivers/staging/rt3070/built-in.o: In function
`RTMPSendDisassociationFrame':
(.text+0x3fff0): multiple definition of `RTMPSendDisassociationFrame'
drivers/staging/rt2870/built-in.o:(.text+0x3c3c0): first defined here
drivers/staging/rt3070/built-in.o: In function
`RtmpUSBNullFrameKickOut':
(.text+0x76048): multiple definition of `RtmpUSBNullFrameKickOut'
drivers/staging/rt2870/built-in.o:(.text+0x72400): first defined here
drivers/staging/rt3070/built-in.o: In function `HashBytesPolynomial':
(.text+0x40054): multiple definition of `HashBytesPolynomial'
drivers/staging/rt2870/built-in.o:(.text+0x3c424): first defined here
drivers/staging/rt3070/built-in.o: In function `InvalidStateWhenAuth':
(.text+0x3a27b): multiple definition of `InvalidStateWhenAuth'
drivers/staging/rt2870/built-in.o:(.text+0x3657f): first defined here
drivers/staging/rt3070/built-in.o: In function `GetEncryptType':
(.text+0x28e26): multiple definition of `GetEncryptType'
drivers/staging/rt2870/built-in.o:(.text+0x24e4c): first defined here
drivers/staging/rt3070/built-in.o: In function `RTMPIoctlMAC':
(.text+0x5a094): multiple definition of `RTMPIoctlMAC'
drivers/staging/rt2870/built-in.o:(.text+0x561d9): first defined here
drivers/staging/rt3070/built-in.o: In function
`WpaSendMicFailureToWpaSupplicant':
(.text+0x499d7): multiple definition of
`WpaSendMicFailureToWpaSupplicant'
drivers/staging/rt2870/built-in.o:(.text+0x45a93): first defined here
drivers/staging/rt3070/built-in.o: In function `DoBulkIn':
(.text+0x73a3c): multiple definition of `DoBulkIn'
drivers/staging/rt2870/built-in.o:(.text+0x6fe78): first defined here
drivers/staging/rt3070/built-in.o: In function `Set_WirelessMode_Proc':
(.text+0x2e6ba): multiple definition of `Set_WirelessMode_Proc'
drivers/staging/rt2870/built-in.o:(.text+0x2a70c): first defined here
drivers/staging/rt3070/built-in.o: In function `MakeIbssBeacon':
(.text+0x440a2): multiple definition of `MakeIbssBeacon'
drivers/staging/rt2870/built-in.o:(.text+0x402aa): first defined here
drivers/staging/rt3070/built-in.o: In function `AuthParmFill':
(.text+0x4480d): multiple definition of `AuthParmFill'
drivers/staging/rt2870/built-in.o:(.text+0x40a15): first defined here
drivers/staging/rt3070/built-in.o: In function `construct_ctr_preload':
(.text+0x206a6): multiple definition of `construct_ctr_preload'
drivers/staging/rt2870/built-in.o:(.text+0x1ea4a): first defined here
drivers/staging/rt3070/built-in.o: In function `RTUSBWakeUp':
(.text+0x70632): multiple definition of `RTUSBWakeUp'
drivers/staging/rt2870/built-in.o:(.text+0x6c806): first defined here
drivers/staging/rt3070/built-in.o: In function
`ba_reordering_resource_release':
(.text+0x67dad): multiple definition of `ba_reordering_resource_release'
drivers/staging/rt2870/built-in.o:(.text+0x63e51): first defined here
drivers/staging/rt3070/built-in.o: In function `RTUSBBulkRxComplete':
(.text+0x7384b): multiple definition of `RTUSBBulkRxComplete'
drivers/staging/rt2870/built-in.o:(.text+0x6fc87): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x44b8): multiple definition of
`CipherSuiteCiscoCCKMLen'
drivers/staging/rt2870/built-in.o:(.data+0x44b8): first defined here
drivers/staging/rt3070/built-in.o: In function `RTMPTkipMixKey':
(.text+0x20b97): multiple definition of `RTMPTkipMixKey'
drivers/staging/rt2870/built-in.o:(.text+0x1ef3b): first defined here
drivers/staging/rt3070/built-in.o: In function `RTMPCompareMemory':
(.text+0x19077): multiple definition of `RTMPCompareMemory'
drivers/staging/rt2870/built-in.o:(.text+0x18127): first defined here
drivers/staging/rt3070/built-in.o: In function `Set_ForceShortGI_Proc':
(.text+0x2c767): multiple definition of `Set_ForceShortGI_Proc'
drivers/staging/rt2870/built-in.o:(.text+0x287d0): first defined here
drivers/staging/rt3070/built-in.o: In function `BbpRadarDetectionStart':
(.text+0x31431): multiple definition of `BbpRadarDetectionStart'
drivers/staging/rt2870/built-in.o:(.text+0x2d569): first defined here
drivers/staging/rt3070/built-in.o: In function
`Set_SendPSMPAction_Proc':
(.text+0x2a0c9): multiple definition of `Set_SendPSMPAction_Proc'
drivers/staging/rt2870/built-in.o:(.text+0x260ef): first defined here
drivers/staging/rt3070/built-in.o: In function `Show_Key3_Proc':
(.text+0x290da): multiple definition of `Show_Key3_Proc'
drivers/staging/rt2870/built-in.o:(.text+0x25100): first defined here
drivers/staging/rt3070/built-in.o: In function `MlmeJoinReqAction':
(.text+0x3e94f): multiple definition of `MlmeJoinReqAction'
drivers/staging/rt2870/built-in.o:(.text+0x3ac43): first defined here
drivers/staging/rt3070/built-in.o: In function `ComposeNullFrame':
(.text+0x44857): multiple definition of `ComposeNullFrame'
drivers/staging/rt2870/built-in.o:(.text+0x40a5f): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x13f0): multiple definition of
`default_cwmin'
drivers/staging/rt2870/built-in.o:(.data+0x13f0): first defined here
drivers/staging/rt3070/built-in.o: In function `RTMPIoctlGetMacTable':
(.text+0x2aa73): multiple definition of `RTMPIoctlGetMacTable'
drivers/staging/rt2870/built-in.o:(.text+0x26a99): first defined here
drivers/staging/rt3070/built-in.o: In function `Set_Key3_Proc':
(.text+0x5b49f): multiple definition of `Set_Key3_Proc'
drivers/staging/rt2870/built-in.o:(.text+0x57223): first defined here
drivers/staging/rt3070/built-in.o: In function
`AuthRspStateMachineInit':
(.text+0x3b389): multiple definition of `AuthRspStateMachineInit'
drivers/staging/rt2870/built-in.o:(.text+0x376f9): first defined here
drivers/staging/rt3070/built-in.o: In function `MiniportMMRequest':
(.text+0x18c77): multiple definition of `MiniportMMRequest'
drivers/staging/rt2870/built-in.o:(.text+0x17d28): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x1400): multiple definition of
`FirmwareImage'
drivers/staging/rt2870/built-in.o:(.data+0x1400): first defined here
drivers/staging/rt3070/built-in.o: In function `EnqueueProbeRequest':
(.text+0x3b4c5): multiple definition of `EnqueueProbeRequest'
drivers/staging/rt2870/built-in.o:(.text+0x37835): first defined here
drivers/staging/rt3070/built-in.o: In function `rt28xx_open':
(.text+0x54d08): multiple definition of `rt28xx_open'
drivers/staging/rt2870/built-in.o:(.text+0x50db0): first defined here
drivers/staging/rt3070/built-in.o: In function `ChannelSanity':
(.text+0x25e85): multiple definition of `ChannelSanity'
drivers/staging/rt2870/built-in.o:(.text+0x21e89): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x4118): multiple definition of
`A_BAND_REGION_8_CHANNEL_LIST'
drivers/staging/rt2870/built-in.o:(.data+0x4118): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x4460): multiple definition of
`CipherWpaPskTkip'
drivers/staging/rt2870/built-in.o:(.data+0x4460): first defined here
drivers/staging/rt3070/built-in.o: In function `InvalidStateWhenAssoc':
(.text+0x35040): multiple definition of `InvalidStateWhenAssoc'
drivers/staging/rt2870/built-in.o:(.text+0x31178): first defined here
drivers/staging/rt3070/built-in.o: In function
`ba_reordering_resource_init':
(.text+0x67963): multiple definition of `ba_reordering_resource_init'
drivers/staging/rt2870/built-in.o:(.text+0x63ba3): first defined here
drivers/staging/rt3070/built-in.o: In function `ChangeToCellPowerLimit':
(.text+0x22301): multiple definition of `ChangeToCellPowerLimit'
drivers/staging/rt2870/built-in.o:(.text+0x206a5): first defined here
drivers/staging/rt3070/built-in.o: In function `rtstrstruncasecmp':
(.text+0x4ff6d): multiple definition of `rtstrstruncasecmp'
drivers/staging/rt2870/built-in.o:(.text+0x4c101): first defined here
drivers/staging/rt3070/built-in.o: In function `Set_BAOriTearDown_Proc':
(.text+0x2a597): multiple definition of `Set_BAOriTearDown_Proc'
drivers/staging/rt2870/built-in.o:(.text+0x265bd): first defined here
drivers/staging/rt3070/built-in.o: In function `PeerAssocRspAction':
(.text+0x35c10): multiple definition of `PeerAssocRspAction'
drivers/staging/rt2870/built-in.o:(.text+0x31d48): first defined here
drivers/staging/rt3070/built-in.o: In function `RtmpUSBDataLastTxIdx':
(.text+0x756c2): multiple definition of `RtmpUSBDataLastTxIdx'
drivers/staging/rt2870/built-in.o:(.text+0x71ab2): first defined here
drivers/staging/rt3070/built-in.o: In function `NICInitializeAsic':
(.text+0x1ad0f): multiple definition of `NICInitializeAsic'
drivers/staging/rt2870/built-in.o:(.text+0x1a2af): first defined here
drivers/staging/rt3070/built-in.o: In function `RTMPTkipPutUInt32':
(.text+0x20030): multiple definition of `RTMPTkipPutUInt32'
drivers/staging/rt2870/built-in.o:(.text+0x1e3d4): first defined here
drivers/staging/rt3070/built-in.o: In function `NICEraseFirmware':
(.text+0x1941e): multiple definition of `NICEraseFirmware'
drivers/staging/rt2870/built-in.o:(.text+0x184ce): first defined here
drivers/staging/rt3070/built-in.o: In function `STAHandleRxMgmtFrame':
(.text+0x42d34): multiple definition of `STAHandleRxMgmtFrame'
drivers/staging/rt2870/built-in.o:(.text+0x3f104): first defined here
drivers/staging/rt3070/built-in.o: In function `rt_ioctl_giwmode':
(.text+0x5663e): multiple definition of `rt_ioctl_giwmode'
drivers/staging/rt2870/built-in.o:(.text+0x52859): first defined here
drivers/staging/rt3070/built-in.o: In function `Set_TxPreamble_Proc':
(.text+0x2e0b2): multiple definition of `Set_TxPreamble_Proc'
drivers/staging/rt2870/built-in.o:(.text+0x2a104): first defined here
drivers/staging/rt3070/built-in.o: In function `BssEntrySet':
(.text+0x1019d): multiple definition of `BssEntrySet'
drivers/staging/rt2870/built-in.o:(.text+0xf577): first defined here
drivers/staging/rt3070/built-in.o: In function `RTMPPatchMacBbpBug':
(.text+0x1bf78): multiple definition of `RTMPPatchMacBbpBug'
drivers/staging/rt2870/built-in.o:(.text+0x1a222): first defined here
drivers/staging/rt3070/built-in.o: In function `ConstructEapolMsg':
(.text+0x301b2): multiple definition of `ConstructEapolMsg'
drivers/staging/rt2870/built-in.o:(.text+0x2c2ea): first defined here
drivers/staging/rt3070/built-in.o: In function `CCKMPRF':
(.text+0x498f4): multiple definition of `CCKMPRF'
drivers/staging/rt2870/built-in.o:(.text+0x459b0): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x510): multiple definition of
`MULTICAST_ADDR'
drivers/staging/rt2870/built-in.o:(.data+0x510): first defined here
drivers/staging/rt3070/built-in.o: In function `RT28XXDMAEnable':
(.text+0x6b645): multiple definition of `RT28XXDMAEnable'
drivers/staging/rt2870/built-in.o:(.text+0x676b5): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x4520): multiple definition of
`pWirelessSysEventText'
drivers/staging/rt2870/built-in.o:(.data+0x4520): first defined here
drivers/staging/rt3070/built-in.o: In function `Set_HtBaWinSize_Proc':
(.text+0x2cbe6): multiple definition of `Set_HtBaWinSize_Proc'
drivers/staging/rt2870/built-in.o:(.text+0x28c38): first defined here
drivers/staging/rt3070/built-in.o: In function `Set_DefaultKeyID_Proc':
(.text+0x583d1): multiple definition of `Set_DefaultKeyID_Proc'
drivers/staging/rt2870/built-in.o:(.text+0x54ac2): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x3d0): multiple definition of
`RateSwitchTable11BGN3SForABand'
drivers/staging/rt2870/built-in.o:(.data+0x3d0): first defined here
drivers/staging/rt3070/built-in.o: In function `rtinet_aton':
(.text+0x4fc84): multiple definition of `rtinet_aton'
drivers/staging/rt2870/built-in.o:(.text+0x4be18): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x3780): multiple definition of
`STAMACRegTable'
drivers/staging/rt2870/built-in.o:(.data+0x3780): first defined here
drivers/staging/rt3070/built-in.o: In function `PeerDisassocAction':
(.text+0x3529b): multiple definition of `PeerDisassocAction'
drivers/staging/rt2870/built-in.o:(.text+0x313d3): first defined here
drivers/staging/rt3070/built-in.o: In function `MD5Transform':
(.text+0x5b): multiple definition of `MD5Transform'
drivers/staging/rt2870/built-in.o:(.text+0x5b): first defined here
drivers/staging/rt3070/built-in.o: In function
`STABuildCache802_11Header':
(.text+0x40399): multiple definition of `STABuildCache802_11Header'
drivers/staging/rt2870/built-in.o:(.text+0x3c769): first defined here
drivers/staging/rt3070/built-in.o: In function `Show_WPAPSK_Proc':
(.text+0x27fdc): multiple definition of `Show_WPAPSK_Proc'
drivers/staging/rt2870/built-in.o:(.text+0x23ffa): first defined here
drivers/staging/rt3070/built-in.o: In function `linux_BeaconTimeout':
(.text+0x4f95b): multiple definition of `linux_BeaconTimeout'
drivers/staging/rt2870/built-in.o:(.text+0x4baef): first defined here
drivers/staging/rt3070/built-in.o: In function `RTMPGetKeyParameter':
(.text+0x50a72): multiple definition of `RTMPGetKeyParameter'
drivers/staging/rt2870/built-in.o:(.text+0x4cc06): first defined here
drivers/staging/rt3070/built-in.o: In function
`CmmRxnonRalinkFrameIndicate':
(.text+0x179b5): multiple definition of `CmmRxnonRalinkFrameIndicate'
drivers/staging/rt2870/built-in.o:(.text+0x16d5f): first defined here
drivers/staging/rt3070/built-in.o: In function `RTMPEnableRxTx':
(.text+0x19335): multiple definition of `RTMPEnableRxTx'
drivers/staging/rt2870/built-in.o:(.text+0x183e5): first defined here
drivers/staging/rt3070/built-in.o: In function `Set_SSID_Proc':
(.text+0x5bd92): multiple definition of `Set_SSID_Proc'
drivers/staging/rt2870/built-in.o:(.text+0x586f2): first defined here
drivers/staging/rt3070/built-in.o: In function `BA_MaxWinSizeReasign':
(.text+0x66fa5): multiple definition of `BA_MaxWinSizeReasign'
drivers/staging/rt2870/built-in.o:(.text+0x631e5): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x563): multiple definition of
`TimIe'
drivers/staging/rt2870/built-in.o:(.data+0x563): first defined here
drivers/staging/rt3070/built-in.o: In function `MlmeADDBAAction':
(.text+0x1454b): multiple definition of `MlmeADDBAAction'
drivers/staging/rt2870/built-in.o:(.text+0x138e3): first defined here
drivers/staging/rt3070/built-in.o: In function `RTMPSoftDecryptWEP':
(.text+0x134a6): multiple definition of `RTMPSoftDecryptWEP'
drivers/staging/rt2870/built-in.o:(.text+0x1283e): first defined here
drivers/staging/rt3070/built-in.o: In function `BssTableSearchWithSSID':
(.text+0xe949): multiple definition of `BssTableSearchWithSSID'
drivers/staging/rt2870/built-in.o:(.text+0xdb39): first defined here
drivers/staging/rt3070/built-in.o: In function
`RTUSBCleanUpMLMEBulkOutQueue':
(.text+0x73351): multiple definition of `RTUSBCleanUpMLMEBulkOutQueue'
drivers/staging/rt2870/built-in.o:(.text+0x6f78d): first defined here
drivers/staging/rt3070/built-in.o: In function `Show_HtGi_Proc':
(.text+0x28636): multiple definition of `Show_HtGi_Proc'
drivers/staging/rt2870/built-in.o:(.text+0x24654): first defined here
drivers/staging/rt3070/built-in.o: In function `STAHandleRxDataFrame':
(.text+0x4365c): multiple definition of `STAHandleRxDataFrame'
drivers/staging/rt2870/built-in.o:(.text+0x3f863): first defined here
drivers/staging/rt3070/built-in.o: In function `CMDHandler':
(.text+0x707d6): multiple definition of `CMDHandler'
drivers/staging/rt2870/built-in.o:(.text+0x6ca54): first defined here
drivers/staging/rt3070/built-in.o: In function `linux_BeaconUpdateExec':
(.text+0x4f9e1): multiple definition of `linux_BeaconUpdateExec'
drivers/staging/rt2870/built-in.o:(.text+0x4bb75): first defined here
drivers/staging/rt3070/built-in.o: In function
`linux_BAOriSessionSetupTimeout':
(.text+0x6a942): multiple definition of `linux_BAOriSessionSetupTimeout'
drivers/staging/rt2870/built-in.o:(.text+0x669af): first defined here
drivers/staging/rt3070/built-in.o: In function
`AironetCreateBeaconReportFromBssTable':
(.text+0x37bb4): multiple definition of
`AironetCreateBeaconReportFromBssTable'
drivers/staging/rt2870/built-in.o:(.text+0x33d58): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x44f8): multiple definition of
`CipherSuiteCCXTkipLen'
drivers/staging/rt2870/built-in.o:(.data+0x44f8): first defined here
drivers/staging/rt3070/built-in.o: In function `NICInitAsicFromEEPROM':
(.text+0x1b9d6): multiple definition of `NICInitAsicFromEEPROM'
drivers/staging/rt2870/built-in.o:(.text+0x19db6): first defined here
drivers/staging/rt3070/built-in.o: In function `rt_ioctl_siwsens':
(.text+0x565a7): multiple definition of `rt_ioctl_siwsens'
drivers/staging/rt2870/built-in.o:(.text+0x527c2): first defined here
drivers/staging/rt3070/built-in.o: In function `AsicSwitchChannel':
(.text+0x9b6f): multiple definition of `AsicSwitchChannel'
drivers/staging/rt2870/built-in.o:(.text+0xa5da): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x43b8): multiple definition of
`OUI_WPA2_WEP40'
drivers/staging/rt2870/built-in.o:(.data+0x43c0): first defined here
drivers/staging/rt3070/built-in.o: In function `RTMPSetPiggyBack':
(.text+0x62a9): multiple definition of `RTMPSetPiggyBack'
drivers/staging/rt2870/built-in.o:(.text+0x663a): first defined here
drivers/staging/rt3070/built-in.o: In function `RTMPTkipAppend':
(.text+0x2121c): multiple definition of `RTMPTkipAppend'
drivers/staging/rt2870/built-in.o:(.text+0x1f5c0): first defined here
drivers/staging/rt3070/built-in.o: In function `RTMPInitWepEngine':
(.text+0x13666): multiple definition of `RTMPInitWepEngine'
drivers/staging/rt2870/built-in.o:(.text+0x129fe): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x40b0): multiple definition of
`A_BAND_REGION_0_CHANNEL_LIST'
drivers/staging/rt2870/built-in.o:(.data+0x40b0): first defined here
drivers/staging/rt3070/built-in.o: In function `Set_HtGi_Proc':
(.text+0x2d036): multiple definition of `Set_HtGi_Proc'
drivers/staging/rt2870/built-in.o:(.text+0x29088): first defined here
drivers/staging/rt3070/built-in.o: In function `RTUSBBulkReceive':
(.text+0x73c22): multiple definition of `RTUSBBulkReceive'
drivers/staging/rt2870/built-in.o:(.text+0x7005e): first defined here
drivers/staging/rt3070/built-in.o: In function `RTMPSetLED':
(.text+0x195c6): multiple definition of `RTMPSetLED'
drivers/staging/rt2870/built-in.o:(.text+0x18676): first defined here
drivers/staging/rt3070/built-in.o: In function `RTMPSetPhyMode':
(.text+0x2d489): multiple definition of `RTMPSetPhyMode'
drivers/staging/rt2870/built-in.o:(.text+0x294db): first defined here
drivers/staging/rt3070/built-in.o: In function `RTMPSendRTSFrame':
(.text+0x40022): multiple definition of `RTMPSendRTSFrame'
drivers/staging/rt2870/built-in.o:(.text+0x3c3f2): first defined here
drivers/staging/rt3070/built-in.o: In function `STA_AMPDU_Frame_Tx':
(.text+0x41a3d): multiple definition of `STA_AMPDU_Frame_Tx'
drivers/staging/rt2870/built-in.o:(.text+0x3de0d): first defined here
drivers/staging/rt3070/built-in.o: In function `RT2870_BssBeaconStop':
(.text+0x6b2a7): multiple definition of `RT2870_BssBeaconStop'
drivers/staging/rt2870/built-in.o:(.text+0x67317): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x240): multiple definition of
`RateSwitchTable11N2SForABand'
drivers/staging/rt2870/built-in.o:(.data+0x240): first defined here
drivers/staging/rt3070/built-in.o: In function `RT28xxUsbMlmeRadioOFF':
(.text+0x7584c): multiple definition of `RT28xxUsbMlmeRadioOFF'
drivers/staging/rt2870/built-in.o:(.text+0x71c3c): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x13f8): multiple definition of
`MapUserPriorityToAccessCategory'
drivers/staging/rt2870/built-in.o:(.data+0x13f8): first defined here
drivers/staging/rt3070/built-in.o: In function `F':
(.text+0x3037): multiple definition of `F'
drivers/staging/rt2870/built-in.o:(.text+0x3037): first defined here
drivers/staging/rt3070/built-in.o: In function `RT2870_TimerQ_Exit':
(.text+0x6c4b0): multiple definition of `RT2870_TimerQ_Exit'
drivers/staging/rt2870/built-in.o:(.text+0x6853b): first defined here
drivers/staging/rt3070/built-in.o: In function `RTMP_QueryPacketInfo':
(.text+0x4d216): multiple definition of `RTMP_QueryPacketInfo'
drivers/staging/rt2870/built-in.o:(.text+0x493aa): first defined here
drivers/staging/rt3070/built-in.o: In function `Set_HtProtect_Proc':
(.text+0x29530): multiple definition of `Set_HtProtect_Proc'
drivers/staging/rt2870/built-in.o:(.text+0x25556): first defined here
drivers/staging/rt3070/built-in.o: In function `CntlIdleProc':
(.text+0x492fe): multiple definition of `CntlIdleProc'
drivers/staging/rt2870/built-in.o:(.text+0x453ba): first defined here
drivers/staging/rt3070/built-in.o: In function `STAMlmePeriodicExec':
(.text+0x11a34): multiple definition of `STAMlmePeriodicExec'
drivers/staging/rt2870/built-in.o:(.text+0x10d89): first defined here
drivers/staging/rt3070/built-in.o:(.data+0x1a): multiple definition of
`WAPI_OUI'
drivers/staging/rt2870/built-in.o:(.data+0x1a): first defined here
drivers/staging/rt3070/built-in.o: In function `RTMPSoftDecryptAES':
(.text+0x213ad): multiple definition of `RTMPSoftDecryptAES'
drivers/staging/rt2870/built-in.o:(.text+0x1f751): first defined here
drivers/staging/rt3070/built-in.o: In function
`AsicUpdateWCIDAttribute':
(.text+0x6931): multiple definition of `AsicUpdateWCIDAttribute'
drivers/staging/rt2870/built-in.o:(.text+0x67fd): first defined here
drivers/staging/rt3070/built-in.o: In function
`ba_reordering_mpdu_insertsorted':
(.text+0x66e3c): multiple definition of
`ba_reordering_mpdu_insertsorted'
drivers/staging/rt2870/built-in.o:(.text+0x6307c): first defined here
drivers/staging/rt3070/built-in.o: In function `Show_HtMcs_Proc':
(.text+0x286ad): multiple definition of `Show_HtMcs_Proc'
drivers/staging/rt2870/built-in.o:(.text+0x246cb): first defined here
drivers/staging/rt3070/built-in.o: In function
`deaggregate_AMSDU_announce':
(.text+0x17565): multiple definition of `deaggregate_AMSDU_announce'
drivers/staging/rt2870/built-in.o:(.text+0x1690f): first defined here
drivers/staging/rt3070/built-in.o: In function
`RTMPGetRalinkEncryModeStr':
(.text+0x27f6e): multiple definition of `RTMPGetRalinkEncryModeStr'
drivers/staging/rt2870/built-in.o:(.text+0x23f84): first defined here
drivers/staging/rt3070/built-in.o: In function `BASessionTearDownALL':
(.text+0x69a4a): multiple definition of `BASessionTearDownALL'
drivers/staging/rt2870/built-in.o:(.text+0x65ab7): first defined here
drivers/staging/rt3070/built-in.o: In function `NICInitializeAdapter':
(.text+0x1b776): multiple definition of `NICInitializeAdapter'
drivers/staging/rt2870/built-in.o:(.text+0x1aa6d): first defined here
drivers/staging/rt3070/built-in.o: In function `BATableAllocOriEntry':
(.text+0x67475): multiple definition of `BATableAllocOriEntry'
drivers/staging/rt2870/built-in.o:(.text+0x636b5): first defined here
drivers/staging/rt3070/built-in.o: In function `MlmeReassocReqAction':
(.text+0x36298): multiple definition of `MlmeReassocReqAction'
drivers/staging/rt2870/built-in.o:(.text+0x323d0): first defined here
drivers/staging/rt3070/built-in.o: In function `rt_ioctl_giwauth':
(.text+0x55c77): multiple definition of `rt_ioctl_giwauth'
drivers/staging/rt2870/built-in.o:(.text+0x51d37): first defined here
make[2]: *** [drivers/staging/built-in.o] Error 1
make[1]: *** [drivers/staging] Error 2
make: *** [drivers] Error 2
---

I did not find any earlier report of this error.

Regards--
Subrata


--=-hEItHhQn+Q//sZ7yOLX/
Content-Disposition: attachment; filename=randconfig1-next20090421-x86_64
Content-Type: text/plain; name=randconfig1-next20090421-x86_64; charset=UTF-8
Content-Transfer-Encoding: 7bit

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.30-rc2
# Tue Apr 21 12:54:01 2009
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_DYNAMIC_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y

#
# RCU Subsystem
#
# CONFIG_CLASSIC_RCU is not set
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB_ALLOCATOR is not set
# CONFIG_SLUB_ALLOCATOR is not set
CONFIG_SLQB_ALLOCATOR=y
CONFIG_SLQB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_IBS=y
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_SLOW_WORK=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_BSG is not set
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=m
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_AS=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="anticipatory"
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
# CONFIG_XEN is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_MEMTEST=y
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
CONFIG_I8K=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=m
CONFIG_X86_CPU_DEBUG=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_UNEVICTABLE_LRU is not set
CONFIG_HAVE_MLOCK=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW_64K=y
# CONFIG_MTRR is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR_ALL=y
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
CONFIG_CMDLINE_OVERRIDE=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_VERBOSE=y
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
# CONFIG_CPU_FREQ_DEBUG is not set
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
# CONFIG_PCI is not set
# CONFIG_ARCH_SUPPORTS_MSI is not set
CONFIG_ISA_DMA_API=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_PCMCIA_IOCTL is not set

#
# PC-card bridges
#

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=m
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
# CONFIG_UNIX is not set
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=m
# CONFIG_NET_IPGRE is not set
CONFIG_IP_MROUTE=y
# CONFIG_IP_PIMSM_V1 is not set
# CONFIG_IP_PIMSM_V2 is not set
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=m
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=m
# CONFIG_TCP_CONG_WESTWOOD is not set
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
CONFIG_TCP_CONG_SCALABLE=y
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETLABEL=y
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
# CONFIG_BRIDGE_NETFILTER is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
# CONFIG_NF_CONNTRACK_EVENTS is not set
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=y
CONFIG_NF_CT_NETLINK=y
CONFIG_NETFILTER_TPROXY=m
CONFIG_NETFILTER_XTABLES=y
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_HL=m
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
# CONFIG_NETFILTER_XT_TARGET_TRACE is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=y
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=y
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
CONFIG_NETFILTER_XT_MATCH_HL=y
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=y
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=y
CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT=y
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=y
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
CONFIG_NETFILTER_XT_MATCH_STRING=y
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
CONFIG_NETFILTER_XT_MATCH_TIME=y
CONFIG_NETFILTER_XT_MATCH_U32=m
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
# CONFIG_NF_CONNTRACK_IPV4 is not set
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=m
# CONFIG_IP_NF_MATCH_ADDRTYPE is not set
# CONFIG_IP_NF_MATCH_AH is not set
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
# CONFIG_IP_NF_TARGET_REJECT is not set
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_ECN=m
# CONFIG_IP_NF_TARGET_TTL is not set
# CONFIG_IP_NF_RAW is not set
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=y
CONFIG_IP_NF_ARPFILTER=y
CONFIG_IP_NF_ARP_MANGLE=y

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=y
CONFIG_IP6_NF_IPTABLES=m
# CONFIG_IP6_NF_MATCH_AH is not set
# CONFIG_IP6_NF_MATCH_EUI64 is not set
CONFIG_IP6_NF_MATCH_FRAG=m
# CONFIG_IP6_NF_MATCH_OPTS is not set
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RT=m
# CONFIG_IP6_NF_TARGET_HL is not set
# CONFIG_IP6_NF_TARGET_LOG is not set
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=m
CONFIG_IP_DCCP=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
CONFIG_IP_DCCP_CCID3_DEBUG=y
CONFIG_IP_DCCP_CCID3_RTO=100
CONFIG_IP_DCCP_TFRC_LIB=y
CONFIG_IP_DCCP_TFRC_DEBUG=y
CONFIG_IP_SCTP=m
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_HMAC_NONE is not set
CONFIG_SCTP_HMAC_SHA1=y
# CONFIG_SCTP_HMAC_MD5 is not set
CONFIG_TIPC=y
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_ZONES=3
CONFIG_TIPC_CLUSTERS=1
CONFIG_TIPC_NODES=255
CONFIG_TIPC_SLAVE_NODES=0
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_LOG=0
CONFIG_TIPC_DEBUG=y
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
CONFIG_ATM_CLIP_NO_ICMP=y
CONFIG_ATM_LANE=m
CONFIG_ATM_MPOA=y
CONFIG_ATM_BR2684=y
CONFIG_ATM_BR2684_IPFILTER=y
CONFIG_STP=m
CONFIG_BRIDGE=m
CONFIG_NET_DSA=y
# CONFIG_NET_DSA_TAG_DSA is not set
CONFIG_NET_DSA_TAG_EDSA=y
# CONFIG_NET_DSA_TAG_TRAILER is not set
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=m
CONFIG_LLC2=m
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
CONFIG_X25=m
CONFIG_LAPB=y
CONFIG_ECONET=y
# CONFIG_ECONET_AUNUDP is not set
CONFIG_ECONET_NATIVE=y
CONFIG_WAN_ROUTER=m
CONFIG_PHONET=y
# CONFIG_NET_SCHED is not set
CONFIG_NET_CLS_ROUTE=y
CONFIG_DCB=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_NET_DROP_MONITOR=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
# CONFIG_CAN_BCM is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
CONFIG_CAN_DEBUG_DEVICES=y
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=m
CONFIG_LIB80211_DEBUG=y
CONFIG_MAC80211=y

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
CONFIG_MAC80211_MESH=y
# CONFIG_MAC80211_LEDS is not set
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT=y
CONFIG_MAC80211_NOINLINE=y
CONFIG_MAC80211_VERBOSE_DEBUG=y
# CONFIG_MAC80211_HT_DEBUG is not set
CONFIG_MAC80211_TKIP_DEBUG=y
CONFIG_MAC80211_IBSS_DEBUG=y
CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
CONFIG_MAC80211_VERBOSE_MPL_DEBUG=y
CONFIG_MAC80211_DEBUG_COUNTERS=y
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
# CONFIG_RFKILL_INPUT is not set
CONFIG_RFKILL_LEDS=y
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
# CONFIG_NET_9P_DEBUG is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=m
CONFIG_MTD_DEBUG=y
CONFIG_MTD_DEBUG_VERBOSE=0
CONFIG_MTD_CONCAT=m
CONFIG_MTD_PARTITIONS=y
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=m
CONFIG_HAVE_MTD_OTP=y
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
# CONFIG_NFTL is not set
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
CONFIG_MTD_CFI_LE_BYTE_SWAP=y
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_2 is not set
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_MAP_BANK_WIDTH_8=y
CONFIG_MTD_MAP_BANK_WIDTH_16=y
CONFIG_MTD_MAP_BANK_WIDTH_32=y
# CONFIG_MTD_CFI_I1 is not set
CONFIG_MTD_CFI_I2=y
CONFIG_MTD_CFI_I4=y
CONFIG_MTD_CFI_I8=y
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=m
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_TS5500=m
CONFIG_MTD_AMD76XROM=m
CONFIG_MTD_ICHXROM=m
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_DILNETPC=m
CONFIG_MTD_DILNETPC_BOOTSIZE=0x80000
CONFIG_MTD_L440GX=m
CONFIG_MTD_PLATRAM=m

#
# Self-contained MTD device drivers
#
CONFIG_MTD_DATAFLASH=m
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
# CONFIG_MTD_DATAFLASH_OTP is not set
CONFIG_MTD_M25P80=m
# CONFIG_M25PXX_USE_FAST_READ is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOC2000=m
# CONFIG_MTD_DOC2001 is not set
CONFIG_MTD_DOC2001PLUS=m
CONFIG_MTD_DOCPROBE=m
CONFIG_MTD_DOCECC=m
# CONFIG_MTD_DOCPROBE_ADVANCED is not set
CONFIG_MTD_DOCPROBE_ADDRESS=0
# CONFIG_MTD_NAND is not set
CONFIG_MTD_NAND_IDS=m
CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y
CONFIG_MTD_ONENAND_SIM=m

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m

#
# UBI - Unsorted block images
#
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_RESERVE=1
CONFIG_MTD_UBI_GLUEBI=y

#
# UBI debugging options
#
CONFIG_MTD_UBI_DEBUG=y
CONFIG_MTD_UBI_DEBUG_MSG=y
CONFIG_MTD_UBI_DEBUG_PARANOID=y
# CONFIG_MTD_UBI_DEBUG_DISABLE_BGT is not set
CONFIG_MTD_UBI_DEBUG_EMULATE_BITFLIPS=y
# CONFIG_MTD_UBI_DEBUG_EMULATE_WRITE_FAILURES is not set
CONFIG_MTD_UBI_DEBUG_EMULATE_ERASE_FAILURES=y

#
# Additional UBI debugging messages
#
# CONFIG_MTD_UBI_DEBUG_MSG_BLD is not set
# CONFIG_MTD_UBI_DEBUG_MSG_EBA is not set
CONFIG_MTD_UBI_DEBUG_MSG_WL=y
CONFIG_MTD_UBI_DEBUG_MSG_IO=y
# CONFIG_PARPORT is not set
# CONFIG_BLK_DEV is not set
CONFIG_MISC_DEVICES=y
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_93CX6=y
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=m
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECS=y
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
CONFIG_BLK_DEV_PLATFORM=m
CONFIG_BLK_DEV_CMD640=m
CONFIG_BLK_DEV_CMD640_ENHANCED=y
# CONFIG_BLK_DEV_IDEDMA is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=y
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
# CONFIG_COMPAT_NET_DEV_OPS is not set
CONFIG_DUMMY=y
# CONFIG_BONDING is not set
CONFIG_MACVLAN=y
CONFIG_EQUALIZER=m
CONFIG_TUN=y
CONFIG_VETH=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=y
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=m
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=m
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_ENC28J60 is not set
CONFIG_ETHOC=y
CONFIG_DNET=m
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_B44=y
# CONFIG_NETDEV_1000 is not set
CONFIG_NETDEV_10000=y

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_USB=m
CONFIG_LIBERTAS_CS=m
# CONFIG_LIBERTAS_SDIO is not set
CONFIG_LIBERTAS_DEBUG=y
CONFIG_LIBERTAS_THINFIRM=m
CONFIG_LIBERTAS_THINFIRM_USB=m
CONFIG_ATMEL=y
# CONFIG_PCMCIA_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_AIRO_CS=m
CONFIG_PCMCIA_WL3501=y
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
CONFIG_RTL8187=y
# CONFIG_MAC80211_HWSIM is not set
CONFIG_P54_COMMON=m
CONFIG_P54_USB=m
CONFIG_P54_SPI=m
CONFIG_AR9170_USB=y
# CONFIG_HOSTAP is not set
CONFIG_B43=y
# CONFIG_B43_PCMCIA is not set
CONFIG_B43_PIO=y
CONFIG_B43_DEBUG=y
CONFIG_B43_FORCE_PIO=y
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
CONFIG_RT2X00=m
CONFIG_RT2500USB=m
CONFIG_RT73USB=m
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_RFKILL=y
CONFIG_RT2X00_LIB_DEBUGFS=y
# CONFIG_RT2X00_DEBUG is not set
# CONFIG_HERMES is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m
CONFIG_WIMAX_I2400M_USB=m
# CONFIG_WIMAX_I2400M_SDIO is not set
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
# CONFIG_USB_KAWETH is not set
CONFIG_USB_PEGASUS=m
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
# CONFIG_USB_BELKIN is not set
# CONFIG_USB_ARMLINUX is not set
CONFIG_USB_EPSON2888=y
# CONFIG_USB_KC2190 is not set
# CONFIG_USB_NET_ZAURUS is not set
CONFIG_USB_HSO=m
# CONFIG_NET_PCMCIA is not set
CONFIG_WAN=y
CONFIG_HDLC=m
# CONFIG_HDLC_RAW is not set
# CONFIG_HDLC_RAW_ETH is not set
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m
# CONFIG_HDLC_X25 is not set
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
CONFIG_WAN_ROUTER_DRIVERS=m
CONFIG_LAPBETHER=m
CONFIG_X25_ASY=m
# CONFIG_SBNI is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=m
CONFIG_ATM_TCP=m
CONFIG_PPP=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
# CONFIG_PPP_ASYNC is not set
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=y
# CONFIG_PPPOATM is not set
# CONFIG_PPPOL2TP is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=m
CONFIG_ISDN=y
CONFIG_MISDN=m
# CONFIG_MISDN_DSP is not set
# CONFIG_MISDN_L1OIP is not set

#
# mISDN hardware drivers
#
# CONFIG_MISDN_HFCUSB is not set
CONFIG_ISDN_I4L=y
CONFIG_ISDN_PPP=y
CONFIG_ISDN_PPP_VJ=y
CONFIG_ISDN_MPP=y
CONFIG_IPPP_FILTER=y
# CONFIG_ISDN_PPP_BSDCOMP is not set
CONFIG_ISDN_AUDIO=y
# CONFIG_ISDN_TTY_FAX is not set
# CONFIG_ISDN_X25 is not set

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=m

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
# CONFIG_ISDN_DRV_HISAX is not set

#
# Active cards
#
CONFIG_ISDN_DRV_GIGASET=m
CONFIG_GIGASET_BASE=m
CONFIG_GIGASET_M105=m
CONFIG_GIGASET_M101=m
CONFIG_GIGASET_DEBUG=y
# CONFIG_GIGASET_UNDOCREQ is not set
# CONFIG_ISDN_CAPI is not set
CONFIG_PHONE=m

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=y
CONFIG_MOUSE_APPLETOUCH=y
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_VSXXXAA=m
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=m
# CONFIG_JOYSTICK_ADI is not set
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=m
CONFIG_TOUCHSCREEN_AD7877=y
# CONFIG_TOUCHSCREEN_AD7879_SPI is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_MTOUCH=m
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_PCSPKR is not set
CONFIG_INPUT_ATI_REMOTE=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_POWERMATE=y
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=m

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_DEVKMEM is not set
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
# CONFIG_SERIAL_8250_RSA is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=m
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
# CONFIG_IPMI_SI is not set
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_VIRTIO=m
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
CONFIG_IPWIRELESS=y
CONFIG_MWAVE=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TELCLOCK=y
# CONFIG_I2C is not set
CONFIG_SPI=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=m

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_DS2490=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_BQ27000=y
# CONFIG_POWER_SUPPLY is not set
# CONFIG_HWMON is not set
CONFIG_THERMAL=m
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=m
CONFIG_SC520_WDT=m
CONFIG_EUROTECH_WDT=m
CONFIG_IB700_WDT=y
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
CONFIG_PC87413_WDT=y
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=m
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
CONFIG_W83697UG_WDT=y
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_SM501=m
CONFIG_HTC_PASIC3=y
# CONFIG_MFD_TMIO is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_BQ24022 is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
# CONFIG_VIDEO_ALLOW_V4L1 is not set
CONFIG_VIDEO_V4L1_COMPAT=y
# CONFIG_DVB_CORE is not set
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_V4L2=m
# CONFIG_VIDEO_CAPTURE_DRIVERS is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_USB_DSBR is not set
# CONFIG_USB_SI470X is not set
CONFIG_USB_MR800=m
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_VGASTATE=m
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=m
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_ARC=m
CONFIG_FB_VGA16=m
# CONFIG_FB_UVESA is not set
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=m
CONFIG_FB_HGA_ACCEL=y
CONFIG_FB_S1D13XXX=m
CONFIG_FB_TMIO=m
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SM501=m
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=m
CONFIG_FB_MB862XX=m
CONFIG_FB_BROADSHEET=m
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_LTV350QV=m
CONFIG_LCD_ILI9320=m
# CONFIG_LCD_TDO24M is not set
CONFIG_LCD_VGG2432A4=m
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_MBP_NVIDIA=m
CONFIG_BACKLIGHT_SAHARA=m

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
CONFIG_HID_GYRATION=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_TOPSEED=y
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB_ARCH_HAS_OHCI is not set
# CONFIG_USB_ARCH_HAS_EHCI is not set
CONFIG_USB=y
CONFIG_USB_DEBUG=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=m
CONFIG_USB_ISP1760_HCD=m
CONFIG_USB_SL811_HCD=m
CONFIG_USB_SL811_CS=m
CONFIG_USB_R8A66597_HCD=m
CONFIG_USB_HWA_HCD=y
# CONFIG_USB_GADGET_MUSB_HDRC is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=y
# CONFIG_USB_SERIAL_CH341 is not set
CONFIG_USB_SERIAL_WHITEHEAT=m
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
CONFIG_USB_SERIAL_CP210X=y
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=m
# CONFIG_USB_SERIAL_FUNSOFT is not set
CONFIG_USB_SERIAL_VISOR=y
CONFIG_USB_SERIAL_IPAQ=y
CONFIG_USB_SERIAL_IR=y
# CONFIG_USB_SERIAL_EDGEPORT is not set
CONFIG_USB_SERIAL_EDGEPORT_TI=y
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
CONFIG_USB_SERIAL_KEYSPAN=y
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
# CONFIG_USB_SERIAL_KEYSPAN_USA18X is not set
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
# CONFIG_USB_SERIAL_MCT_U232 is not set
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
# CONFIG_USB_SERIAL_MOTOROLA is not set
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=y
CONFIG_USB_SERIAL_OTI6858=y
CONFIG_USB_SERIAL_QUALCOMM=y
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=y
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
CONFIG_USB_SERIAL_TI=y
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
CONFIG_USB_SERIAL_OMNINET=y
CONFIG_USB_SERIAL_OPTICON=y
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=m
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=y
# CONFIG_USB_BERRY_CHARGE is not set
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=m
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_VST=m
# CONFIG_USB_ATM is not set
CONFIG_USB_GADGET=m
CONFIG_USB_GADGET_DEBUG_FILES=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_SELECTED=y
# CONFIG_USB_GADGET_AT91 is not set
# CONFIG_USB_GADGET_ATMEL_USBA is not set
# CONFIG_USB_GADGET_FSL_USB2 is not set
# CONFIG_USB_GADGET_LH7A40X is not set
# CONFIG_USB_GADGET_OMAP is not set
# CONFIG_USB_GADGET_PXA25X is not set
# CONFIG_USB_GADGET_PXA27X is not set
# CONFIG_USB_GADGET_S3C2410 is not set
# CONFIG_USB_GADGET_IMX is not set
CONFIG_USB_GADGET_M66592=y
CONFIG_USB_M66592=m
# CONFIG_USB_GADGET_AMD5536UDC is not set
# CONFIG_USB_GADGET_FSL_QE is not set
# CONFIG_USB_GADGET_CI13XXX is not set
# CONFIG_USB_GADGET_NET2280 is not set
# CONFIG_USB_GADGET_GOKU is not set
# CONFIG_USB_GADGET_DUMMY_HCD is not set
CONFIG_USB_GADGET_DUALSPEED=y
CONFIG_USB_ZERO=m
CONFIG_USB_ETH=m
# CONFIG_USB_ETH_RNDIS is not set
CONFIG_USB_GADGETFS=m
# CONFIG_USB_FILE_STORAGE is not set
CONFIG_USB_G_SERIAL=m
# CONFIG_USB_MIDI_GADGET is not set
CONFIG_USB_G_PRINTER=m
CONFIG_USB_CDC_COMPOSITE=m

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_NOP_USB_XCEIV=m
CONFIG_UWB=y
CONFIG_UWB_HWA=y
# CONFIG_UWB_WLP is not set
CONFIG_UWB_I1480U=y
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_UNSAFE_RESUME=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_WBSD=y
# CONFIG_MMC_SPI is not set
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_NEW_LEDS=y
# CONFIG_LEDS_CLASS is not set

#
# LED drivers
#

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
# CONFIG_LEDS_TRIGGER_IDE_DISK is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_DEBUG_VERBOSE=y
CONFIG_EDAC_MM_EDAC=m
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=m

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T94=m
# CONFIG_RTC_DRV_DS1305 is not set
CONFIG_RTC_DRV_DS1390=m
CONFIG_RTC_DRV_MAX6902=m
CONFIG_RTC_DRV_R9701=m
# CONFIG_RTC_DRV_RS5C348 is not set
CONFIG_RTC_DRV_DS3234=m

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_BQ4802=m
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
# CONFIG_UIO_PDRV is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_SMX=m
CONFIG_UIO_SERCOS3=m
CONFIG_STAGING=y
# CONFIG_STAGING_EXCLUDE_BUILD is not set
# CONFIG_MEILHAUS is not set
# CONFIG_USB_IP_COMMON is not set
# CONFIG_W35UND is not set
CONFIG_PRISM2_USB=m
CONFIG_ECHO=y
# CONFIG_USB_ATMEL is not set
# CONFIG_AGNX is not set
# CONFIG_OTUS is not set
CONFIG_RT2870=y
CONFIG_RT3070=y
CONFIG_COMEDI=m
CONFIG_COMEDI_DEBUG=y
# CONFIG_COMEDI_PCMCIA_DRIVERS is not set
CONFIG_COMEDI_USB_DRIVERS=m
CONFIG_ASUS_OLED=m
CONFIG_INPUT_MIMIO=m
CONFIG_TRANZPORT=m
CONFIG_EPL=y

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ANDROID_LOGGER=m
CONFIG_ANDROID_RAM_CONSOLE=y
# CONFIG_ANDROID_RAM_CONSOLE_ENABLE_VERBOSE is not set
CONFIG_ANDROID_RAM_CONSOLE_EARLY_INIT=y
CONFIG_ANDROID_RAM_CONSOLE_EARLY_ADDR=0
CONFIG_ANDROID_RAM_CONSOLE_EARLY_SIZE=0
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
# CONFIG_POHMELFS is not set
CONFIG_STLC45XX=m
CONFIG_USB_SERIAL_ATEN2011=m
CONFIG_B3DFG=y
CONFIG_PLAN9AUTH=m
CONFIG_HECI=y
# CONFIG_USB_SERIAL_QUATECH_ESU100 is not set
CONFIG_X86_PLATFORM_DEVICES=y

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set

#
# File systems
#
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=m
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4DEV_COMPAT=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_FS_XIP=y
CONFIG_JBD=m
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
# CONFIG_GFS2_FS_LOCKING_DLM is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=y
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=m
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=m
CONFIG_BEFS_DEBUG=y
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
CONFIG_UBIFS_FS=m
CONFIG_UBIFS_FS_XATTR=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
CONFIG_UBIFS_FS_LZO=y
# CONFIG_UBIFS_FS_ZLIB is not set
# CONFIG_UBIFS_FS_DEBUG is not set
CONFIG_CRAMFS=m
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=y
# CONFIG_QNX4FS_FS is not set
CONFIG_ROMFS_FS=m
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
# CONFIG_ROMFS_BACKED_BY_MTD is not set
CONFIG_ROMFS_BACKED_BY_BOTH=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
# CONFIG_NILFS2_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
# CONFIG_NFS_V3 is not set
CONFIG_NFS_V4=y
# CONFIG_NFS_V4_1 is not set
CONFIG_NFS_FSCACHE=y
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
# CONFIG_NFSD_V4 is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_RPCSEC_GSS_SPKM3 is not set
CONFIG_SMB_FS=m
CONFIG_SMB_NLS_DEFAULT=y
CONFIG_SMB_NLS_REMOTE="cp437"
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
# CONFIG_CIFS_WEAK_PW_HASH is not set
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_EXPERIMENTAL is not set
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
# CONFIG_NCPFS_STRONG is not set
CONFIG_NCPFS_NFS_NS=y
# CONFIG_NCPFS_OS2_NS is not set
CONFIG_NCPFS_SMALLDOS=y
# CONFIG_NCPFS_NLS is not set
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_CODA_FS=y
CONFIG_AFS_FS=y
CONFIG_AFS_DEBUG=y
CONFIG_9P_FS=m

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=m
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=m
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=y
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_SLQB_DEBUG is not set
# CONFIG_SLQB_SYSFS is not set
CONFIG_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK_TEST is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_FTRACE_SYSCALLS=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
CONFIG_TRACING=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_FUNCTION_GRAPH_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SYSPROF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_ENABLE_EVENT_TRACING=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BOOT_TRACER=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
# CONFIG_BRANCH_TRACER is not set
# CONFIG_POWER_TRACER is not set
# CONFIG_STACK_TRACER is not set
CONFIG_KMEMTRACE=y
CONFIG_WORKQUEUE_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_DYNAMIC_FTRACE=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_SAMPLES=y
CONFIG_SAMPLE_MARKERS=m
CONFIG_SAMPLE_TRACEPOINTS=m
CONFIG_SAMPLE_TRACE_EVENTS=y
CONFIG_SAMPLE_KOBJECT=m
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
# CONFIG_SECURITY_PATH is not set
CONFIG_SECURITY_FILE_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=m
CONFIG_CRYPTO_FPU=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_VIRTUALIZATION=y
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m
CONFIG_VIRTIO_BALLOON=m
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y

--=-hEItHhQn+Q//sZ7yOLX/--

