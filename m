Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbZLUQmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbZLUQmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbZLUQmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:42:43 -0500
Received: from cobra.newdream.net ([66.33.216.30]:49700 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbZLUQmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:42:42 -0500
Date: Mon, 21 Dec 2009 08:42:42 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: Andi Kleen <andi@firstfloor.org>
cc: Jim Garlick <garlick@llnl.gov>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, greg@kroah.com
Subject: Re: [GIT PULL] Ceph distributed file system client for 2.6.33
In-Reply-To: <87ws0jtegi.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0912192115050.8993@cobra.newdream.net>
References: <Pine.LNX.4.64.0912071511470.32397@cobra.newdream.net>
 <Pine.LNX.4.64.0912181140370.26094@cobra.newdream.net>
 <alpine.LFD.2.00.0912181327200.3712@localhost.localdomain>
 <20091218231505.GA21371@llnl.gov> <87ws0jtegi.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Dec 2009, Andi Kleen wrote:

> Jim Garlick <garlick@llnl.gov> writes:
> >
> > Ceph is new and experimental so you're not going to see production shops
> 
> One issue with ceph is that I'm not sure it has any users at all.
> The mailing list seems to be pretty much dead?
> On a philosophical area I agree that network file systems are
> definitely an area that could need some more improvements.

The list is slow.  The developers all work in the same office, so most of 
the technical discussion ends up face to face (we're working on moving 
more of it to the list).  I also tend to send users actively testing it to 
the irc channel.  

That said, there aren't many active users.  I see lots of interested 
people lurking on the list and 'waiting for stability,' but I think the 
prospect of testing an unstable cluster fs is much more daunting than a 
local one.

If you want stability, then it's probably too early to merge.  If you want 
active users, that essentially hinges on stability too.  But if it's 
interest in/demand for an alternative distributed fs, then the sooner it's 
merged the better.  

>From my point of view merging now will be a bit rockier with coordinating 
releases, bug fixes, and dealing with any unforseen client side changes, 
but I think it'll be worth it.  OTOH, another release cycle will bring 
greater stability and better first impressions.

sage
