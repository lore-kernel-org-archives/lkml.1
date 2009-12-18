Return-Path: <linux-kernel-owner+w=401wt.eu-S1751879AbZLRXZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbZLRXZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 18:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbZLRXZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 18:25:08 -0500
Received: from nspiron-3.llnl.gov ([128.115.41.83]:49497 "EHLO smtp.llnl.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750752AbZLRXZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 18:25:07 -0500
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Dec 2009 18:25:07 EST
X-Attachments: None
Date: Fri, 18 Dec 2009 15:15:05 -0800
From: Jim Garlick <garlick@llnl.gov>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sage Weil <sage@newdream.net>, Gregory Haskins <gregory.haskins@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Ceph distributed file system client for 2.6.33
Message-ID: <20091218231505.GA21371@llnl.gov>
References: <Pine.LNX.4.64.0912071511470.32397@cobra.newdream.net> <Pine.LNX.4.64.0912181140370.26094@cobra.newdream.net> <alpine.LFD.2.00.0912181327200.3712@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912181327200.3712@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 01:38:00PM -0800, Linus Torvalds wrote:
> On Fri, 18 Dec 2009, Sage Weil wrote:
> > 
> > I would still like to see ceph merged for 2.6.33.  It's certainly not 
> > production ready, but it would be greatly beneficial to be in mainline for 
> > the same reasons other file systems like btrfs and exofs were merged 
> > early.
> 
> The best thing to do is to try to have users that are vocal about the 
> feature, and talk about how great it is. Some advocates for it, in other 
> words. Just a few other people saying "hey, I use this, it's great", is 
> actually a big deal to me. For alacrityvm and cephfs, I didn't have that, 
> or they just weren't loud enough for me to hear.

FWIW: I'd like to see it go in.

Ceph is new and experimental so you're not going to see production shops
like ours jumping up and down saying we use it and are tired of merging it,
like we would say if if Lustre were (again) on the table.

However I will say Ceph looks good and in the interest of nuturing future
options, I'm for merging it!

Jim Garlick
Lawrence Livermore National Laboratory
