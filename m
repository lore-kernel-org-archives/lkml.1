Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbZFKQ7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbZFKQ7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbZFKQ6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:58:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754182AbZFKQ6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:58:53 -0400
Date: Thu, 11 Jun 2009 09:58:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
In-Reply-To: <20090611165226.GV8633@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.01.0906110956270.3573@localhost.localdomain>
References: <20090611160329.GA3366@elte.hu> <20090611161714.GA5008@infradead.org> <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain> <20090611165226.GV8633@ZenIV.linux.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Jun 2009, Al Viro wrote:
> 
> Yes.  So's sysfs, so's udev, so's hal, so's any number of revolting
> strings of intertwined copulating tapeworms hanging off the kernel's arse.

Those are about a different thing, though - they are largely about policy. 
Very different from something like profiling (or graphics acceleration).

I do like your visuals, though.

			Linus
