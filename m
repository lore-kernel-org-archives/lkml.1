Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbXJBWNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbXJBWNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 18:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbXJBWNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 18:13:43 -0400
Received: from mail.tmr.com ([64.65.253.246]:37260 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbXJBWNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 18:13:42 -0400
Message-ID: <4702C401.4050009@tmr.com>
Date: Tue, 02 Oct 2007 18:19:45 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: shutdown -h now, 2.6.23-rc8 & 9
References: <200710020650.02613.gene.heskett@gmail.com>
In-Reply-To: <200710020650.02613.gene.heskett@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> Greetings everybody;
> 
> After seeing a message indicating that rc8 no longer did a powerdown, I 
> thought I'd check that since I needed to, my tv card wasn't even showing up 
> in the lspci report. It was partially backed out of the pci slot, this case 
> seems to encourage that.
> 
I have rc8-git3 running on several machines, and I'm delighted to say 
that it powers down, reboots, and suspends to mem/disk without bothering 
to patch in suspend2. I saw the same message, but perhaps git3 had the 
fix, since machines go down correctly. I'm going to boot a laptop off CD 
  and try the rc9 on that to see if the wireless issues I had to patch 
around are fixed as promised. If so I'll go to the newest kernel for 
power saving.

> Indeed it went to the system halted message and just sat there.  I hadn't yet 
> booted to rc9 as amanda was running, so I did just a few minutes ago.
> 
> After the reboot to rc9, I ran a make xconfig again to check that the option 
> was enabled, but it seems to have disappeared from the menus in xconfig.
> 
> Why was this removed?  Or if moved, where to?
> 
What? Was what removed?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
