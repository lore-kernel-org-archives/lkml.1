Return-Path: <linux-kernel-owner+w=401wt.eu-S1758343AbYE0Nmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343AbYE0Nmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 09:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757522AbYE0Nmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 09:42:37 -0400
Received: from valhalla.ausics.net ([58.96.38.4]:36489 "EHLO
	valhalla.ausics.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277AbYE0Nmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 09:42:36 -0400
X-AIS-Watermark: 1212500540.10258@YwvT+IE+/XmV2b40v9ZIYw
Subject: Re: PROBLEM: Serial error
From: "Noel   (Sourceforge)" <noelb@users.sourceforge.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <483C0DBF.6030702@gmail.com>
References: <1211836442.5745.1.camel@roswell.ausics.net>
	 <483B3B7C.1000306@gmail.com> <483C0CDD.2000409@gmail.com>
	 <483C0DBF.6030702@gmail.com>
Content-Type: text/plain
Organization: Supporting Open Source
Message-Id: <1211895738.1698.12.camel@roswell.ausics.net>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.4.5 (1.4.5-7) 
Date: Tue, 27 May 2008 23:42:19 +1000
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-27 at 23:33, Jiri Slaby wrote:
> Jiri Slaby napsal(a):
> >>> 01:0c.0 Serial controller: PLX Technology, Inc. PCI <-> IOBus Bridge
> >>> (rev 01) (prog-if 00 [8250])
> >>>         Subsystem: Stallion Technologies, Inc. Unknown device f010
> >>
> >> Do you have some patched driver or whatever, that this binds?
> 
> And please post
> lspci -vvxxs 01:0c.0
> 
> I didn't get how this binds to *stallion drivers.

lspci -vvxxs 01:0c.0
01:0c.0 Serial controller: PLX Technology, Inc. PCI <-> IOBus Bridge
(rev 01) (prog-if 00 [8250])
        Subsystem: Stallion Technologies, Inc. Unknown device f010
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 6
        Region 0: Memory at fd9ffc00 (32-bit, non-prefetchable)
[size=128]
        Region 1: I/O ports at dc00 [size=128]
        Region 2: I/O ports at d880 [size=128]
00: b5 10 50 90 03 01 80 02 01 00 00 07 08 00 00 00
10: 00 fc 9f fd 01 dc 00 00 81 d8 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 4d 12 10 f0
30: 00 00 00 00 00 00 00 00 00 00 00 00 06 01 00 00



Thanks


