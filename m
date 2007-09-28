Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbXI1DIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbXI1DIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 23:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbXI1DIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 23:08:15 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3257 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106AbXI1DIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 23:08:14 -0400
Date: Thu, 27 Sep 2007 22:30:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       tomas.winkler@intel.com
Subject: Re: iwl4965 and driver merging policy
Message-ID: <20070928023055.GI7991@tuxdriver.com>
References: <1190943567.6158.50.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190943567.6158.50.camel@pasglop>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 11:39:27AM +1000, Benjamin Herrenschmidt wrote:

> Just a little question in the light of the discussion we had at Kernel
> Summit about merging drivers upstream (and here, I strongly agree with
> Linus, hence my message).

You must not have been watching me SPAM netdev for the past two
weeks. :-)

> I just got that new T61 laptop which happens to have an iwl4xxx chip.
> The distro I installed on it (ubuntu) has a driver for it. I suspect
> others do too and most users get it from some random external tree and
> use it.
> 
> Thus my question, why are we about to release 2.6.23 without it ?
> 
> It doesn't seem to pull any depedency nor affect any other external
> piece of code unless I'm missing something, so it's a perfect example of
> what we've been discussing back then: there is just no point not merging
> it at any time right ? :-)

It is queued for 2.6.24.  I'm not even sure it was originally posted
in time for the 2.6.23 merge window, but even if it was there was
a lot of opposition to merging it until fairly recently.  In fact,
I'm sure there are still some wireless developers that are less than
happy about merging it now.

Anyway, coming soon to a kernel near you...

John
-- 
John W. Linville
linville@tuxdriver.com
