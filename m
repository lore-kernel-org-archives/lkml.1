Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbZFWTC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbZFWTC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbZFWTCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:02:15 -0400
Received: from vena.lwn.net ([206.168.112.25]:48155 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbZFWTCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:02:14 -0400
Date: Tue, 23 Jun 2009 13:02:13 -0600
From: Jake Edge <jake@lwn.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       "corbet@lwn.net" <corbet@lwn.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "tshibata@ab.jp.nec.com" <tshibata@ab.jp.nec.com>
Subject: Re: [PATCH v3.1415] Documentation: add documentation summary for
 rc-series and merge window
Message-ID: <20090623130213.36b8ba8e@chukar>
In-Reply-To: <20090623175533.GK5305@mosca>
References: <20090622222217.GH23972@bombadil.infradead.org>
	<m3fxdqj2bz.fsf@lwn.net>
	<20090623175533.GK5305@mosca>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 10:55:33 -0700 Luis R. Rodriguez wrote:

> You're right, thanks, will add that. Since you bring this up, are
> there a lot of trees not using the foo-next-2.6.git convention?

Hmm, it seems like I have seen a wide variety of tree names and/or
branch names included in the git pull requests ... also, the tree/branch
names used in linux-next:
http://linux.f-seidel.de/linux-next/pmwiki/pmwiki.php?n=Linux-next.IncludedTrees
seem to be all over the map ...

> > Again, seemingly too rigid based on what really happens ... but
> > maybe this is documenting the "ideal"
> 
> Well I take it that the maintainers who know they can get away with
> some excemptions here don't need to read this to figure that out. But
> I suppose it may be worth mentioning excemptions do exist, for the
> record. BTW, just curious, are there any examples of this?

I think you have created a new word: excemptions :)  I kinda like it,
but I think you mean exceptions.

I think there are multiple examples of new features being merged after
-rc1, but nothing comes to mind immediately ... I think the plan is to
only add features during the merge window, but it occasionally gets
overridden ...

> Yes, thanks. BTW are you up for taking a stab at this yourself? I'm
> not sure when I'll be able to again.

Jon may have some comments, when he has a chance to look ... let's see
where it goes from there ...

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
