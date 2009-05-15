Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbZEOVuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbZEOVuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 17:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757165AbZEOVuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 17:50:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40255 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756889AbZEOVuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 17:50:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Francis Moreau <francis.moro@gmail.com>
Subject: Re: v2.6.30-rc4: b44: eth0: BUG! Timeout waiting for bit 00000002 of register 42c to clear.
Date: Fri, 15 May 2009 23:50:26 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5-rjw; KDE/4.2.2; x86_64; ; )
Cc: Florian Fainelli <florian@openwrt.org>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <38b2ab8a0905030922x722a45f3gf0790b5b90b0f2b3@mail.gmail.com> <200905031828.14468.florian@openwrt.org> <38b2ab8a0905031012m5d50b68es22e3c80cfa72fd60@mail.gmail.com>
In-Reply-To: <38b2ab8a0905031012m5d50b68es22e3c80cfa72fd60@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905152350.27270.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 May 2009, Francis Moreau wrote:
> Hello Florian,
> 
> On Sun, May 3, 2009 at 6:28 PM, Florian Fainelli <florian@openwrt.org> wrote:
> >> I got this since I updated my kernel from 2.6.29 to 2.6.30-rc4.
> >>
> >> Let me know if you need more information.
> >
> > Is this seen on a Broadcom 47xx/53xx platform or on a computer with a PCI b44
> > card ?
> >
> 
> $ lspci -vv
> 
> 06:01.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX (rev 02)
>         Subsystem: Acer Incorporated [ALI] Device 0090
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 64
>         Interrupt: pin A routed to IRQ 21
>         Region 0: Memory at d2000000 (32-bit, non-prefetchable) [size=8K]
>         Capabilities: <access denied>
>         Kernel driver in use: b44
> 
> 
> Let me know if you need more details.

Can anyone please tell me what the status of this report is?

Rafael
