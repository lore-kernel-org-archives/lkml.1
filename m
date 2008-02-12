Return-Path: <linux-kernel-owner+w=401wt.eu-S1764045AbYBLSC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764045AbYBLSC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763842AbYBLSCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:02:47 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51311 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763836AbYBLSCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:02:46 -0500
Message-ID: <47B1DF42.2090808@garzik.org>
Date: Tue, 12 Feb 2008 13:02:42 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
In-Reply-To: <20080212120208.f7168a91.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Andrew was looking for someone to run a linux-next tree that just
> contained the subsystem git and quilt trees for 2.6.x+1 and I (in a
> moment of madness) volunteered.  So, this is to announce the creating of
> such a tree (it doesn't exist yet) which will require some (hopefully)
> small amount of work on the part of subsystem maintainers.


As noted to Andrew in private email, I think this would be great.

akpm's -mm tree tends to have "x+1" changes in it, and also stuff that's 
not fully baked yet.  I would definitely like to see a tree composed of 
all the sub-trees where maintainers said "yes, I think this is baked and 
ready for x+1".  Then -mm and not-yet-baked git changes can layer on top 
of that.

As others are noting, API changes require some coordination amongst 
ourselves (should be our job, not yours, really) and historically we 
haven't been so good at that -- in part because IMO there hasn't been 
any system thing better than a heads-up email in place.

	Jeff


