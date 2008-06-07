Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbYFGTov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbYFGTov (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 15:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbYFGToo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 15:44:44 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:41648 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbYFGTon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 15:44:43 -0400
Message-ID: <484AE520.7050001@krogh.cc>
Date: Sat, 07 Jun 2008 21:44:32 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc5
References: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not that they seem critical to the system but I do get alot of these. I 
cant remember having seen that before.

[    2.874884] Switched to high resolution mode on CPU 13
[    2.904452] system 00:06: ioport range 0x190-0x193 has been reserved
[    2.904456] system 00:06: ioport range 0x4d0-0x4d1 has been reserved
[    2.904465] system 00:06: iomem range 0xffb80000-0xfffffffe could not 
be reserved
[    2.904467] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904469] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904471] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904473] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904475] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904477] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904479] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904481] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904483] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904484] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904486] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904488] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904490] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904492] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904494] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904496] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904498] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904500] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904502] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904504] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904506] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904508] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904510] system 00:06: iomem range 0x0-0x0 could not be reserved
[    2.904522] system 00:09: ioport range 0xcf8-0xcff could not be reserved
[    2.904524] system 00:09: ioport range 0xca0-0xcaf has been reserved
[    2.904541] system 00:09: iomem range 0xfec00000-0xfec00fff could not 
be reserved
[    2.904543] system 00:09: iomem range 0xfee00000-0xfeefffff could not 
be reserved
[    2.904545] system 00:09: iomem range 0xfefff000-0xfeffffff has been 
reserved
[    2.904547] system 00:09: iomem range 0x0-0x0 could not be reserved
[    2.904549] system 00:09: iomem range 0x0-0x0 could not be reserved
[    2.904551] system 00:09: iomem range 0x0-0x0 could not be reserved
[    2.904552] system 00:09: iomem range 0x0-0x0 could not be reserved
[    2.904554] system 00:09: iomem range 0x0-0x0 could not be reserved
[    2.904556] system 00:09: iomem range 0x0-0x0 could not be reserved
[    2.904558] system 00:09: iomem range 0x0-0x0 could not be reserved
[    2.904560] system 00:09: iomem range 0x0-0x0 could not be reserved

Full dmesg log here: http://krogh.cc/~jesper/dmesg

-- 
Jesper
