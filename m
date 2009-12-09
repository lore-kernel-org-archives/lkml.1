Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbZLIFQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbZLIFQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 00:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbZLIFQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 00:16:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55900 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751990AbZLIFQQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 00:16:16 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 09 Dec 2009 05:16:17 +0000
Message-ID: <1260335777.4532.248.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 4/5] firmware/WHENCE: Use consistent field name for licence
 information
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep the Americans happy by making it 'license' not 'licence'.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 firmware/WHENCE |   94 +++++++++++++++++++++++++++---------------------------
 1 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/firmware/WHENCE b/firmware/WHENCE
index 7cee2da..0fe3972 100644
--- a/firmware/WHENCE
+++ b/firmware/WHENCE
@@ -12,7 +12,7 @@ Driver: ambassador -- Madge Ambassador (Collage PCI 155 Server) ATM NIC.
 
 File: atmsar11.fw
 
-Licence: Allegedly GPLv2+, but no source visible. Marked:
+License: Allegedly GPLv2+, but no source visible. Marked:
 
   Madge Ambassador ATM Adapter microcode.
   Copyright (C) 1995-1999  Madge Networks Ltd.
@@ -30,7 +30,7 @@ Driver: korg1212 -- Korg 1212 IO audio device
 
 File: korg/k1212.dsp
 
-Licence: Unknown
+License: Unknown
 
 Found in alsa-firmware package in hex form; no licensing information.
 
@@ -41,7 +41,7 @@ Driver: maestro3 -- ESS Allegro Maestro3 audio device
 File: ess/maestro3_assp_kernel.fw
 File: ess/maestro3_assp_minisrc.fw
 
-Licence: Unknown
+License: Unknown
 
 Found in alsa-firmware package in hex form with a comment claiming to
 be GPLv2+, but without source -- and with another comment saying "ESS
@@ -56,7 +56,7 @@ File: yamaha/ds1_ctrl.fw
 File: yamaha/ds1_dsp.fw
 File: yamaha/ds1e_ctrl.fw
 
-Licence: Unknown
+License: Unknown
 
 Found alsa-firmware package in hex form, with the following comment:
    Copyright (c) 1997-1999 Yamaha Corporation. All Rights Reserved.
@@ -70,7 +70,7 @@ File: advansys/3550.bin
 File: advansys/38C0800.bin
 File: advansys/38C1600.bin
 
-Licence: BSD, no source available.
+License: BSD, no source available.
 
 Found in hex form in kernel source.
 
@@ -82,7 +82,7 @@ File: qlogic/1040.bin
 File: qlogic/1280.bin
 File: qlogic/12160.bin
 
-Licence: Allegedly GPLv2+, but no source visible. Marked:
+License: Allegedly GPLv2+, but no source visible. Marked:
 
                    QLOGIC LINUX SOFTWARE
   QLogic ISP1280/ device driver for Linux 2.2.x and 2.4.x
@@ -94,7 +94,7 @@ Driver: smctr -- SMC ISA/MCA Token Ring adapter
 File: tr_smctr.bin
 Info: MCT.BIN v6.3C1 03/01/95
 
-Original licence info:
+License:
 
  * This firmware is licensed to you strictly for use in conjunction
  * with the use of SMC TokenRing adapters. There is no waranty
@@ -109,7 +109,7 @@ File: kaweth/new_code_fix.bin
 File: kaweth/trigger_code.bin
 File: kaweth/trigger_code_fix.bin
 
-Licence: Unknown
+License: Unknown
 
 Found in hex form in the kernel source.
 
@@ -119,7 +119,7 @@ Driver: ttusb-budget -- Technotrend/Hauppauge Nova-USB devices
 
 File: ttusb-budget/dspbootcode.bin
 
-Licence: Unknown
+License: Unknown
 
 Found in hex form in the kernel source.
 
@@ -142,7 +142,7 @@ File: keyspan/usa49wlc.fw
 
 Converted from Intel HEX files, used in our binary representation of ihex.
 
-Original licence information:
+License:
 
 		Copyright (C) 1999-2001
 		Keyspan, A division of InnoSys Incorporated ("Keyspan")
@@ -172,7 +172,7 @@ Source: keyspan_pda/keyspan_pda.S
 File: keyspan_pda/xircom_pgs.fw
 Source: keyspan_pda/xircom_pgs.S
 
-Licence: GPLv2+
+License: GPLv2+
 
 Compiled from original 8051 source into Intel HEX, used in our binary ihex form.
 
@@ -190,7 +190,7 @@ File: emi26/loader.fw
 
 Converted from Intel HEX files, used in our binary representation of ihex.
 
-Original licence information:
+License:
 /*
  * This firmware is for the Emagic EMI 2|6 Audio Interface
  *
@@ -231,7 +231,7 @@ Info: VERSION=1.04.062 DATE=16.10.2002
 
 Converted from Intel HEX files, used in our binary representation of ihex.
 
-Original licence information: None
+License: Unknown
 
 --------------------------------------------------------------------------
 
@@ -243,7 +243,7 @@ Info: firmware 9/10/04 FW3410_Special_StartWdogOnStartPort
 File: ti_5052.fw
 Info: firmware 9/18/04
 
-Licence: Allegedly GPLv2+, but no source visible. Marked:
+License: Allegedly GPLv2+, but no source visible. Marked:
 	 Copyright (C) 2004 Texas Instruments
 
 Found in hex form in kernel source.
@@ -256,7 +256,7 @@ File: mts_cdma.fw
 File: mts_gsm.fw
 File: mts_edge.fw
 
-Licence: "all firmware components are redistributable in binary form"
+License: "all firmware components are redistributable in binary form"
          per support@multitech.com
 	 Copyright (C) 2005 Multi-Tech Systems, Inc.
 
@@ -272,7 +272,7 @@ Version: 4.06
 File: whiteheat_loader.fw
 File: whiteheat_loader_debug.fw
 
-Licence: Allegedly GPLv2, but no source visible. Marked:
+License: Allegedly GPLv2, but no source visible. Marked:
 	 Copyright (C) 2000-2002  ConnectTech Inc
 
 Debug loader claims the following behaviour:
@@ -289,7 +289,7 @@ Driver: ip2 -- Computone IntelliPort Plus serial device
 
 File: intelliport2.bin
 
-Licence: Unknown
+License: Unknown
 
 Found in hex form in kernel source.
 
@@ -299,7 +299,7 @@ Driver: CPiA2 -- cameras based on Vision's CPiA2
 
 File: cpia2/stv0672_vp4.bin
 
-Licence: Allegedly GPLv2+, but no source visible. Marked:
+License: Allegedly GPLv2+, but no source visible. Marked:
 	Copyright (C) 2001 STMicroelectronics, Inc.
 	Contact:  steve.miller@st.com
 	Description: This file contains patch data for the CPiA2 (stv0672) VP4.
@@ -313,7 +313,7 @@ Driver: DABUSB -- Digital Audio Broadcasting (DAB) Receiver for USB and Linux
 File: dabusb/firmware.fw
 File: dabusb/bitstream.bin
 
-Licence: Distributable
+License: Distributable
 
  * Copyright (C) 1999 BayCom GmbH
  *
@@ -328,7 +328,7 @@ Driver: USB_VICAM -- USB 3com HomeConnect (aka vicam)
 
 File: vicam/firmware.fw
 
-Licence: Unknown
+License: Unknown
 
 Found in hex form in kernel source.
 
@@ -341,7 +341,7 @@ File: edgeport/boot2.fw
 File: edgeport/down.fw
 File: edgeport/down2.fw
 
-Licence: Allegedly GPLv2+, but no source visible. Marked:
+License: Allegedly GPLv2+, but no source visible. Marked:
 //**************************************************************
 //* Edgeport/4 Binary Image
 //* Generated by HEX2C v1.06
@@ -357,7 +357,7 @@ Driver: USB_SERIAL_EDGEPORT_TI - USB Inside Out Edgeport Serial Driver
 
 File: edgeport/down3.bin
 
-Licence:
+License:
 //**************************************************************
 //* Edgeport Binary Image (for TI based products)
 //* Generated by TIBin2C v2.00 (watchport)
@@ -373,7 +373,7 @@ Driver: ATARI_DSP56K - Atari DSP56k support
 File: dsp56k/bootstrap.bin
 Source: dsp56k/bootstrap.asm
 
-Licence: GPLv2 or later
+License: GPLv2 or later
 
 DSP56001 assembler, possibly buildable with a56 from 
 http://www.zdomain.com/a56.html
@@ -388,7 +388,7 @@ File: sb16/ima_adpcm_init.csp
 File: sb16/ima_adpcm_playback.csp
 File: sb16/ima_adpcm_capture.csp
 
-Licence: Allegedly GPLv2+, but no source visible. Marked:
+License: Allegedly GPLv2+, but no source visible. Marked:
 /*
  *  Copyright (c) 1994 Creative Technology Ltd.
  *  Microcode files for SB16 Advanced Signal Processor
@@ -402,7 +402,7 @@ Driver: CASSINI - Sun Cassini
 
 File: sun/cassini.bin
 
-Licence: Unknown
+License: Unknown
 
 Found in hex form in kernel source.
 
@@ -424,7 +424,7 @@ File: cxgb3/ael2005_opt_edc.bin
 File: cxgb3/ael2005_twx_edc.bin
 File: cxgb3/ael2020_twx_edc.bin
 
-Licence:
+License:
  *	Copyright (c) 2007-2009 NetLogic Microsystems, Inc.
  *
  *	Permission is hereby granted for the distribution of this firmware
@@ -441,7 +441,7 @@ File: e100/d101m_ucode.bin
 File: e100/d101s_ucode.bin
 File: e100/d102e_ucode.bin
 
-Licence: Unknown
+License: Unknown
 
 Found in hex form in kernel source.
 
@@ -452,7 +452,7 @@ Driver: acenic -- Alteon AceNIC Gigabit Ethernet card
 File: acenic/tg1.bin
 File: acenic/tg2.bin
 
-Licence: Unknown
+License: Unknown
 
 Found in hex form in kernel source, but source allegedly available at
 http://alteon.shareable.org/
@@ -465,7 +465,7 @@ File: tigon/tg3.bin
 File: tigon/tg3_tso.bin
 File: tigon/tg3_tso5.bin
 
-Licence:
+License:
  * Firmware is:
  *	Derived from proprietary unpublished source code,
  *	Copyright (C) 2000-2003 Broadcom Corporation.
@@ -483,7 +483,7 @@ Driver: ADAPTEC_STARFIRE - Adaptec Starfire/DuraLAN support
 File: adaptec/starfire_rx.bin
 File: adaptec/starfire_tx.bin
 
-Licence: Allegedly GPLv2, but no source visible.
+License: Allegedly GPLv2, but no source visible.
 
 Found in hex form in kernel source, with the following notice:
 
@@ -501,7 +501,7 @@ Driver: TEHUTI - Tehuti Networks 10G Ethernet
 
 File: tehuti/bdx.bin
 
-Licence:
+License:
 
  Copyright (C) 2007 Tehuti Networks Ltd.
 
@@ -517,7 +517,7 @@ Driver: TYPHOON - 3cr990 series Typhoon
 
 File: 3com/typhoon.bin
 
-Licence:
+License:
 /*
  * Copyright 1999-2004 3Com Corporation.  All Rights Reserved.
  *
@@ -560,7 +560,7 @@ Driver: YAM - YAM driver for AX.25
 File: yam/1200.bin
 File: yam/9600.bin
 
-Licence:
+License:
  * (C) F6FBB 1998
 
 Found in hex form in kernel source.
@@ -571,7 +571,7 @@ Driver: 3C359 - 3Com 3C359 Token Link Velocity XL adapter
 
 File: 3com/3C359.bin
 
-Licence:
+License:
 /*
  * The firmware this driver downloads into the tokenring card is a
  * separate program and is not GPL'd source code, even though the Linux
@@ -602,7 +602,7 @@ File: cis/NE2K.cis
 File: cis/tamarack.cis
 File: cis/PE-200.cis
 
-Licence: GPL
+License: GPL
 
 Originally developed by the pcmcia-cs project
 
@@ -612,7 +612,7 @@ Driver: PCMCIA_3C589 - 3Com PCMCIA adapter
 
 File: cis/3CXEM556.cis
 
-Licence: GPL
+License: GPL
 
 Originally developed by the pcmcia-cs project
 
@@ -622,7 +622,7 @@ Driver: PCMCIA_3C574 - 3Com PCMCIA adapter
 
 File: cis/3CCFEM556.cis
 
-Licence: GPL
+License: GPL
 
 Originally developed by the pcmcia-cs project
 
@@ -638,7 +638,7 @@ File: cis/SW_555_SER.cis
 File: cis/SW_7xx_SER.cis
 File: cis/SW_8xx_SER.cis
 
-Licence: GPL
+License: GPL
 
 Originally developed by the pcmcia-cs project
 
@@ -648,7 +648,7 @@ Driver: PCMCIA_SMC91C92 - SMC 91Cxx PCMCIA
 
 File: ositech/Xilinx7OD.bin
 
-Licence: Allegedly GPL, but no source visible. Marked:
+License: Allegedly GPL, but no source visible. Marked:
     This file contains the firmware of Seven of Diamonds from OSITECH.
     (Special thanks to Kevin MacPherson of OSITECH)
 
@@ -660,7 +660,7 @@ Driver: SCSI_QLOGICPTI - PTI Qlogic, ISP Driver
 
 File: qlogic/isp1000.bin
 
-Licence: Unknown
+License: Unknown
 
 Found in hex form in kernel source.
 
@@ -670,7 +670,7 @@ Driver: MYRI_SBUS - MyriCOM Gigabit Ethernet
 
 File: myricom/lanai.bin
 
-Licence: Unknown
+License: Unknown
 
 Found in hex form in kernel source.
 
@@ -704,7 +704,7 @@ File: bnx2/bnx2-mips-09-5.0.0.j3.fw
 File: bnx2/bnx2-rv2p-09-5.0.0.j3.fw
 File: bnx2/bnx2-rv2p-09ax-5.0.0.j3.fw
 
-Licence:
+License:
 
  This file contains firmware data derived from proprietary unpublished
  source code, Copyright (c) 2004 - 2009 Broadcom Corporation.
@@ -721,7 +721,7 @@ Driver: DVB AV7110 -- AV7110 cards
 
 File: av7110/bootcode.bin
 
-Licence: GPLv2 or later
+License: GPLv2 or later
 
 ARM assembly source code available at http://www.linuxtv.org/downloads/firmware/Boot.S
 
@@ -731,7 +731,7 @@ Driver: wavefront - ISA WaveFront sound card
 
 File: yamaha/yss225_registers.bin
 
-Licence: Allegedly GPLv2+, but no source visible.
+License: Allegedly GPLv2+, but no source visible.
 
 Found in hex form in kernel source, with the following comment:
    Copyright (c) 1998-2002 by Paul Davis <pbd@op.net>
@@ -743,7 +743,7 @@ Driver: mga - Matrox G200/G400/G550
 File: matrox/g200_warp.fw
 File: matrox/g400_warp.fw
 
-Licence:
+License:
 
 Copyright 1999 Matrox Graphics Inc.
 All Rights Reserved.
@@ -774,7 +774,7 @@ Driver: r128 - ATI Rage 128
 
 File: r128/r128_cce.bin
 
-Licence:
+License:
 
 Copyright 2000 Advanced Micro Devices, Inc.
 
@@ -831,7 +831,7 @@ File: radeon/RV730_me.bin
 File: radeon/RV710_pfp.bin
 File: radeon/RV710_me.bin
 
-Licence:
+License:
 
  * Copyright 2007-2009 Advanced Micro Devices, Inc.
  * All Rights Reserved.
-- 
1.6.5.3



