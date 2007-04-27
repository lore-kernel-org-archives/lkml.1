Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbXD0QBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbXD0QBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbXD0QBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:01:10 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755950AbXD0QBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:01:08 -0400
Date: Fri, 27 Apr 2007 09:00:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Artem Bityutskiy <dedekind@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>
Subject: Re: [GIT-PULL] please pull UBI tree
In-Reply-To: <1177677925.7539.18.camel@sauron>
Message-ID: <alpine.LFD.0.98.0704270855300.9964@woody.linux-foundation.org>
References: <1177677925.7539.18.camel@sauron>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Apr 2007, Artem Bityutskiy wrote:
>
> Linus, please, pull UBI tree from
> git://git.infradead.org/ubi-2.6.git for-linus
> 
> The UBI tree has been in -mm for several releases and we would like to
> see it in the mainline.

Quite frankly, I have absolutely _zero_ visibility into things like this, 
so before I merge it I want ack's from various layers (preferably a 
mixture of interests - are any vendors interested, is DavidW ok with this, 
who is using it now and are the interfaces and designs correct etc etc?)

So I simply cannot make that decision. I don't have the expertise or the 
knowledge. I'll have to trust somebody else for things like this, and it 
should be somebody who isn't "personally involved". 

In other words, I kind of want a sign-off from other parties, because I 
can't pull things like this "blind".

Are there (embedded?) vendors that already integrate this into their 
kernel, or wait for it? Is dwmw supportive of this? Questions, questions..

			Linus
