Return-Path: <linux-kernel-owner+w=401wt.eu-S1946814AbXD3U7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946814AbXD3U7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 16:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946819AbXD3U7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 16:59:00 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:26563 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946814AbXD3U67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 16:58:59 -0400
Message-ID: <46365887.3010705@interia.pl>
Date: Mon, 30 Apr 2007 22:58:47 +0200
From: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Natsemi DP83815 driver spaming
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EMID: b140eacc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have Wyse 3360SE terminal running Linux 2.6.21-rc7. Everything 
works great with one small exception. Natsemi DP83815 driver is 
filling log with:
> ezri user.info kernel: eth0: DSPCFG accepted after 0 usec.
> ezri user.notice kernel: eth0: Wake-up event 0x80000a
> ezri user.info kernel: eth0: Setting full-duplex based on negotiated link capability.
every 5 seconds. I can comment out these messages, but I would 
like to turn off the source of wake up event. It is a bit 
strange to see wakeup event on running system. 

Please CC me.

Thank You
Rafał

natsemi dp8381x driver, version 2.1, Sept 11, 2006
  originally by Donald Becker <becker@scyld.com>
  http://www.scyld.com/network/natsemi.html
  2.4.x kernel port by Jeff Garzik, Tjeerd Mulder
PCI: Setting latency timer of device 0000:00:0f.0 to 64
natsemi eth0: NatSemi DP8381[56] at 0x10010000 (0000:00:0f.0), 00:80:64:10:c6:09, IRQ 10, port TP.

00:0f.0 Ethernet controller: National Semiconductor Corporation DP83815 (MacPhyter) Ethernet Controller
	Subsystem: National Semiconductor Corporation DP83815 (MacPhyter) Ethernet Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (2750ns min, 13000ns max)
	Interrupt: pin A routed to IRQ 10
	Region 0: I/O ports at f800 [size=256]
	Region 1: Memory at 10010000 (32-bit, non-prefetchable) [size=4K]
	[virtual] Expansion ROM at 10000000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=320mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+



----------------------------------------------------------------------
NIE KUPUJ!!!
...zanim nie porownasz cen >> http://link.interia.pl/f1a5e



