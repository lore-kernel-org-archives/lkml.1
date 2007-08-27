Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbXH0OrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbXH0OrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 10:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbXH0OrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 10:47:10 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:5792 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbXH0OrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 10:47:09 -0400
Subject: Re: Who wants to maintain KR list for stable releases? (was Re:
	nmi_watchdog=2 regression in 2.6.21)
From: Daniel Walker <dwalker@mvista.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <46D21E8E.4000003@googlemail.com>
References: <1186531609.22044.50.camel@imap.mvista.com>
	 <20070808142059.GF30805@atjola.homenet>
	 <1187628296.7732.14.camel@imap.mvista.com>
	 <46CDE94A.7000600@googlemail.com>
	 <1187904169.2435.83.camel@dhcp193.mvista.com>
	 <46D21E8E.4000003@googlemail.com>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 07:39:26 -0700
Message-Id: <1188225567.2435.188.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-27 at 02:45 +0200, Michal Piotrowski wrote:
> Daniel Walker pisze:
> [snip]
> > Have you considered maintaining all the lists in Bugzilla?
> 
> Yes, I have considered it.
> 
> Bugzilla sucks when it comes to tracking things. There is
> a regression field, but there are no difference between
> 2.6.22 and 2.6.23 regression.
> 
> Most people are reporting bugs through LKML:
> - 23 regressions with reference to LKML
> - 4 regressions with reference to Bugzilla

The main reason that I commented on this was because of your comment
below in the release emails,

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

And I was thinking, if these bugz need to transition over the bugzilla
anyway why not go straight there instead of via kernelnewbies .. People
would just get bugzilla accounts and open new bugz entry.

I not trying to force you into something , and ultimately it whatever is
easier for you.. Which was my main reason for commenting on it.

> > If you had a
> > search of open bugs they would just fall of the list as they get
> > closed.. 
> 
> Unfortunately, the world is not perfect.

I think over time it would work like that , but I'm sure there's lots of
people who don't care about our bugzilla ..

Daniel

