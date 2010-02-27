Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968063Ab0B0JZM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 04:25:12 -0500
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:18905 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968038Ab0B0JZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 04:25:09 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEBAENziEtR9vav/2dsb2JhbAAHpCKyUYR7BA
Message-ID: <4B88E4F3.4010308@cauwe.org>
Date: Sat, 27 Feb 2010 10:25:07 +0100
From: Xavier Miller <xavier.miller@cauwe.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100205 Thunderbird/3.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>, nando@ccrma.Stanford.EDU,
       Carsten Emde <ce@ceag.ch>
Subject: Re: [ANNOUNCE] 2.6.33-rt3
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain> <alpine.LFD.2.00.1002262041020.4245@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002262041020.4245@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The name is -rt4, not -rt3

Xavier Miller.

Le 26/02/10 20:54, Thomas Gleixner a écrit :
> We are pleased to announce the next update to our new preempt-rt
> series.
> 
>     - Update to 2.6.33
> 
>     - rt fixes:
> 
>       	 Peter Zijlstra (1):
>     	       highmem, -rt: Implement pfn and prot kmaps
> 
> 	Thomas Gleixner (2):
>       	       x86: pci: Prevent mmconfig memory corruption
>       	       mmc: omap_hsmmc: Fix the locking mess
> 
> A note on the development process:
> 
>   The rt/2.6.33 branch is now stabilization only. The rt/head branch
>   will follow linus tree from now on, so it will inherit all
>   (mis)features which come in the merge window.
> 
> Download locations:
>    
>    http://www.kernel.org/pub/linux/kernel/projects/rt/
> 
> Git development branch:
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/head
> 
> Git release branch:
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/2.6.33
> 
> Gitweb:
>    http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=rt/2.6.33
> 
> Information on the RT patch can be found at:
> 
>    http://rt.wiki.kernel.org/index.php/Main_Page
>  
> To build the 2.6.33-rt3 tree, the following patches should be
> applied:
> 
>    http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.33.tar.bz2
>    http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.33-rt3.bz2
> 
> Enjoy !
> 
>       tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
