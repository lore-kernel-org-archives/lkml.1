Return-Path: <linux-kernel-owner+w=401wt.eu-S1760285AbYGPQdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760285AbYGPQdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758097AbYGPQdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:33:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:34005 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051AbYGPQdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:33:13 -0400
Date: Wed, 16 Jul 2008 09:29:49 -0700
From: Greg KH <greg@kroah.com>
To: pageexec@freemail.hu
Cc: Tiago Assumpcao <tiago@assumpcao.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
Message-ID: <20080716162949.GA7480@kroah.com>
References: <20080716144347.GB13253@kroah.com> <487E3333.30028.20014B8F@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487E3333.30028.20014B8F@pageexec.freemail.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 05:43:15PM +0200, pageexec@freemail.hu wrote:
> > Take a look at the words I used, if someone can't determine if they
> > should upgrade or not based on that,
> 
> your carefully chosen words are *wrong* in fact.

I do not think so, but you are free to disagree.

> exploiting local bugs has nothing to do with having untrusted users in
> the age of client side exploits. due to your completely
> mischaracterized description, individual home users may very well feel
> that they do not need to upgrade, to the delight of the next malware
> owning their browser. you can congratulate yourself Greg, you
> successfully misled a whole class of users.

No, I do not believe this is true, for this bug, sorry.  If you
disagree, please feel free to post such an exploit.  Such a problem
would be a browser issue, and totally out of scope for a kernel issue.

> > then they need to rely on a company
> > to provide updates for them, and not be running their own kernels
> > because they really have no clue about system management.
> 
> you conveniently failed to respond to the rest of my mail where i showed
> that Chris Wright, heck, even yourself did announce security fixes as such
> in the past. how do you explain that?

I am human and as such, word things differently at times.  Based on crap
like this thread, and from discussions with Linus and others, trying to
classify such things as "security fixes" all the time isn't useful or
helpful.

Again, I still feel my original wording was sufficent.  If you disagree,
feel free to start releasing your own kernels with whatever wording you
like.  If people find them useful, perhaps they will use them instead of
the ones I do at times.

good luck,

greg k-h
