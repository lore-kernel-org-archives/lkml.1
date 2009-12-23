Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbZLWWXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbZLWWXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 17:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbZLWWXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 17:23:47 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:53926 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470AbZLWWXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 17:23:46 -0500
Date: Wed, 23 Dec 2009 17:23:46 -0500
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, leoli@freescale.com
Subject: Re: ucc_geth broken in 2.6.32 by
	864fdf884e82bacbe8ca5e93bd43393a61d2e2b4
Message-ID: <20091223222346.GI760@caffeine.csclub.uwaterloo.ca>
References: <20091223174019.GB762@caffeine.csclub.uwaterloo.ca> <20091223180415.GA12987@oksana.dev.rtsoft.ru> <20091223200948.GF760@caffeine.csclub.uwaterloo.ca> <20091223202226.GA8185@oksana.dev.rtsoft.ru> <20091223221047.GH760@caffeine.csclub.uwaterloo.ca> <20091223222116.GA851@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091223222116.GA851@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 24, 2009 at 01:21:16AM +0300, Anton Vorontsov wrote:
> On Wed, Dec 23, 2009 at 05:10:47PM -0500, Lennart Sorensen wrote:
> [...]
> > That seems to be it.  It works now.  No more crashes.
> > Those two patches together seem to do the trick.
> 
> Great!
> 
> > I really hope they
> > can go into 2.6.32-stable then, since this is a regression over 2.6.31
> > and is hopefully an obvious fix.
> 
> Yep, will try to get them there.
> 
> Thanks a lot for helping to track this down,

Thanks for fixing it so fast.  I only knew that patch broke it, not why
it broke it.

-- 
Len Sorensen
