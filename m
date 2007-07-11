Return-Path: <linux-kernel-owner+w=401wt.eu-S937212AbXGLAEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937212AbXGLAEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935820AbXGKXqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:46:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57802 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934456AbXGKXqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:46:05 -0400
Date: Wed, 11 Jul 2007 16:45:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
In-Reply-To: <20070711231912.GA32263@elte.hu>
Message-ID: <alpine.LFD.0.999.0707111641320.20061@woody.linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
 <alpine.LFD.0.999.0707111438530.20061@woody.linux-foundation.org>
 <20070711231912.GA32263@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 12 Jul 2007, Ingo Molnar wrote:
> 
> We also integrated _all_ feedback we got, and we had the capacity and 
> capability to fix whatever other feedback comes back - it just never 
> came ... until today.

One thing I'll happily talk about is that while 2.6.21 was painful, you 
and Thomas in particular were both very responsible about the thing, so 
no, I'm not at all complaining or worried about it in that sense!

I just really _really_ wish we could have two fairly stable releases in a 
row. I think 2.6.22 has the potential to be a pretty good setup, and I'd 
really like to avoid having another 2.6.21 immediately afterwards.

So I'm not worried about integration and getting fixes when things break 
per se, but I *am* worried that this is an area where we've traditionally 
had lots of unexpected problems.

And hey, maybe this time there will be none. I just still smart from the 
last time, so I'd prefer it to go more smoothly this time around.

		Linus
