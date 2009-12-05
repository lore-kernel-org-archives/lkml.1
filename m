Return-Path: <linux-kernel-owner+w=401wt.eu-S1757610AbZLEA0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbZLEA0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 19:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757514AbZLEA0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 19:26:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757451AbZLEA0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 19:26:04 -0500
Date: Fri, 4 Dec 2009 16:24:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Yinghai Lu <yinghai@kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: pci_find_parent_resource patch
In-Reply-To: <20091204155922.4e8b76b1@jbarnes-piketon>
Message-ID: <alpine.LFD.2.00.0912041624310.24579@localhost.localdomain>
References: <0AC7ED80-C475-4635-8EFA-6BB18B90D994@kernel.org> <20091204155922.4e8b76b1@jbarnes-piketon>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Dec 2009, Jesse Barnes wrote:

> On Tue, 24 Nov 2009 16:22:20 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > Jesse Barnes wrote:
> > > I don't remember seeing it, is it for 2.6.32?
> > I
> > http://lkml.org/lkml/2009/8/7/352
> > 
> > not sure. better to make it in pci-next for a while.
> > 
> > in my local tree for a while
> 
> Wow, that's an old one.  Linus said a few times he didn't want that one
> to go upstream though.
> 
> Linus?  You mentioned something about re-working it a bit...

Oh, no, I'm perfectly fine with it. I just think it needs testing. Merging 
it early in the merge window is fine.

		Linus
