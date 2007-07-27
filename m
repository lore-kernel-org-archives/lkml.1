Return-Path: <linux-kernel-owner+w=401wt.eu-S937582AbXG0RuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937582AbXG0RuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 13:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932876AbXG0Rtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 13:49:53 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:25354 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933074AbXG0Rtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 13:49:52 -0400
Date: Fri, 27 Jul 2007 10:53:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: use relevant mailing lists
Message-Id: <20070727105343.6486c74a.randy.dunlap@oracle.com>
In-Reply-To: <20070726173140.a76ff4a6.akpm@linux-foundation.org>
References: <20070726170857.dbb42674.randy.dunlap@oracle.com>
	<20070726173140.a76ff4a6.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 17:31:40 -0700 Andrew Morton wrote:

> On Thu, 26 Jul 2007 17:08:57 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > +	Use the relevant mailing list(s) -- don't just send everything to
> > +	lkml (linux-kernel@vger.kernel.org).
> 
> True.
> 
> I personally only troll lkml for unloved patches, so I suspect that a
> random patch which is sent to mailing-list-A and not to lkml has a higher
> probability of getting lost than one which is sent to both lists.  Plus
> it'd be nice to get lkml's patch-to-noise ratio above one percent.

Yes (to P-N ratio).

I'd really like to see netdev patches going to netdev (only :)
and SCSI patches to linux-scsi (only), e.g., unless they actually
address some linux-arch like issue(s).

However, those maintainers are quite different regarding patch
handling.  Maybe you could try to address some of that at that
Cambridge/September event.

> So I'd suggest that you rework the text here to make it clearer that
> patches should go to lkml _and_ to the subsystem-specific mailing list.

Patch is withdrawn.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
