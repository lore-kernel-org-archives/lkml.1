Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbXKFSv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbXKFSv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757337AbXKFSvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:51:35 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:2644 "EHLO
	outbound6-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757321AbXKFSvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:51:33 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Message-ID: <20071106183646.250961000@amd.com>
References: <20071106183645.951275000@amd.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 19:36:48 +0100
From: "Robert Richter" <robert.richter@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
cc: "Robert Richter" <robert.richter@amd.com>
Subject: [patch 3/6] x86: apicdef unification: whitespace changes only
X-OriginalArrivalTime: 06 Nov 2007 18:47:57.0964 (UTC)
 FILETIME=[8C8A84C0:01C820A5]
MIME-Version: 1.0
X-WSS-ID: 6B2E696D24S1590837-06-01
Content-Disposition: inline;
 filename="apicdef/0003-apicdef-whitespace-changes-only.patch"
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 include/asm-x86/apicdef_32.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

Index: linux-perfmon/include/asm-x86/apicdef_32.h
===================================================================
--- linux-perfmon.orig/include/asm-x86/apicdef_32.h
+++ linux-perfmon/include/asm-x86/apicdef_32.h
@@ -37,7 +37,7 @@
 #define			APIC_SPIV_FOCUS_DISABLED	(1<<9)
 #define			APIC_SPIV_APIC_ENABLED		(1<<8)
 #define		APIC_ISR	0x100
-#define         APIC_ISR_NR     0x8     /* Number of 32 bit ISR registers. */
+#define		APIC_ISR_NR	0x8	/* Number of 32 bit ISR registers. */
 #define		APIC_TMR	0x180
 #define 	APIC_IRR	0x200
 #define 	APIC_ESR	0x280
@@ -121,7 +121,6 @@
  */
 #define u32 unsigned int
 
-
 struct local_apic {
 
 /*000*/	struct { u32 __reserved[4]; } __reserved_01;

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com



