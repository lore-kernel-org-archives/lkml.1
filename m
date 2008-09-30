Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbYI3PQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbYI3PQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 11:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYI3PQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 11:16:36 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:43691 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751330AbYI3PQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 11:16:36 -0400
Date: Tue, 30 Sep 2008 17:16:22 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
Message-ID: <20080930151622.GC18961@anita.doom>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20080829212146.GA4321@anita> <48B90F7F.8040308@kernel.org> <48D89C85.2080104@panasas.com> <20080924084846.GA2094@anita> <48DA0A2C.8010008@kernel.org> <20080924105943.GB2094@anita> <20080925081848.GB2305@anita> <48DEA40D.40709@kernel.org> <20080930081257.GB18961@anita.doom> <48E232FC.1090902@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E232FC.1090902@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2008-09-30 23:09 +0900 schrieb Tejun Heo:

> hardreset problem.  Can you please post the result of "lspci -nn"?

00:00.0 Host bridge [0600]: nVidia Corporation nForce3 250Gb Host Bridge [10de:00e1] (rev a1)
00:01.0 ISA bridge [0601]: nVidia Corporation nForce3 250Gb LPC Bridge [10de:00e0] (rev a2)
00:01.1 SMBus [0c05]: nVidia Corporation nForce 250Gb PCI System Management [10de:00e4] (rev a1)
00:02.0 USB Controller [0c03]: nVidia Corporation CK8S USB Controller [10de:00e7] (rev a1)
00:02.1 USB Controller [0c03]: nVidia Corporation CK8S USB Controller [10de:00e7] (rev a1)
00:02.2 USB Controller [0c03]: nVidia Corporation nForce3 EHCI USB 2.0 Controller [10de:00e8] (rev a2)
00:05.0 Bridge [0680]: nVidia Corporation CK8S Ethernet Controller [10de:00df] (rev a2)
00:06.0 Multimedia audio controller [0401]: nVidia Corporation nForce3 250Gb AC'97 Audio Controller [10de:00ea] (rev a1)
00:08.0 IDE interface [0101]: nVidia Corporation CK8S Parallel ATA Controller (v2.5) [10de:00e5] (rev a2)
00:0a.0 IDE interface [0101]: nVidia Corporation CK8S Serial ATA Controller (v2.5) [10de:00e3] (rev a2)
00:0b.0 PCI bridge [0604]: nVidia Corporation nForce3 250Gb AGP Host to PCI Bridge [10de:00e2] (rev a2)
00:0e.0 PCI bridge [0604]: nVidia Corporation nForce3 250Gb PCI-to-PCI Bridge [10de:00ed] (rev a2)
00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration [1022:1100]
00:18.1 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map [1022:1101]
00:18.2 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller [1022:1102]
00:18.3 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control [1022:1103]
01:00.0 VGA compatible controller [0300]: nVidia Corporation NV34 [GeForce FX 5200] [10de:0322] (rev a1)
02:06.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ [10ec:8139] (rev 10)



-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
