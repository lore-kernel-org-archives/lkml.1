Return-Path: <linux-kernel-owner+w=401wt.eu-S1761511AbXEOGFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761511AbXEOGFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 02:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbXEOGFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 02:05:16 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56210 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758814AbXEOGFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 02:05:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46494D8E.2080503@s5r6.in-berlin.de>
Date: Tue, 15 May 2007 08:05:02 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, Tilman Schmidt <tilman@imap.cc>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc1
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>	 <4647569D.7010709@imap.cc>	 <Pine.LNX.4.61.0705141918180.9570@yvahk01.tjqt.qr>	 <4648A3DF.7040004@imap.cc>	 <Pine.LNX.4.61.0705142227350.9570@yvahk01.tjqt.qr>	 <a781481a0705141934u6b369dd5ob1715f14890af914@mail.gmail.com> <a781481a0705141942x3033c72alf8bf7e9582bb59d7@mail.gmail.com>
In-Reply-To: <a781481a0705141942x3033c72alf8bf7e9582bb59d7@mail.gmail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> Or perhaps we could change the text associated with these
> "menu-only" dummy constructs instead ...
> 
>> we really screw the text-based "make oldconfig" folks who think
>> that they're taking a build-related (and not presentation-related)
>> decision when confronted with a:
> 
> So:
> 
>> Ethernet (1000 Mbit) (NETDEV_1000) [Y/n] (NEW)
> 
> becomes:
> 
> [MENU] Ethernet (1000 Mbit) (NETDEV_1000) [Y/n] (NEW)

Make menuconfig and xconfig already have hints that these are menus.
Make oldconfig and gconfig and maybe others lack such hints.
-- 
Stefan Richter
-=====-=-=== -=-= -====
http://arcgraph.de/sr/
