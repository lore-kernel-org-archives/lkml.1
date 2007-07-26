Return-Path: <linux-kernel-owner+w=401wt.eu-S936397AbXGZSTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936397AbXGZSTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934860AbXGZSTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:19:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:50402 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934213AbXGZSTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:19:11 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: david@lang.hm
Subject: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1
Date: Thu, 26 Jul 2007 14:18:34 -0400
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200707251238.50218.lenb@kernel.org> <200707261345.29902.lenb@kernel.org> <Pine.LNX.4.64.0707261056010.4183@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707261056010.4183@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707261418.34434.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > I was actually asking how somebody's _system_ has been degraded
> > by this change -- but I haven't got an objective answer to that one yet.
> 
> how about the fact that Linus found the problem becouse his system didn't 
> work right?

I guess I missed that message.  What system didn't work right,
and how did it fail?


> > The context for this is the EPA ENERGY STAR specification for Computers,
> > which went into effect this month.  This spec says that systems which
> > can not automatically go into suspend within 15 minutes of idle
> > can _not_ earn a sticker.  No sticker, no client computer sales to governments.
> > If Linux can't get STR working, broadly deployed, and enabled by default,
> > then our plans for world domination are going to take a significant hit.
> 
> isn't the sticker and specification for hardware? but in any case not all 
> hardware needs to get that sticker.

No, the sticker is for the entire system (HW+SW) as shipped to the customer.
ie. It is possible for the same hardware solution running Windows
to earn a sticker and land a sale, while Linux fails to earn a sticker
and loses the contract.

You're right, not all systems need to earn the sticker.
Indeed, ENERGY STAR is supposed to be a "premium" brand.
However, several governments disqualify bids for large
contracts if they do not meet ENERGY STAR.

> > yes, I understand that there are SMP systems that want ACPI and don't
> > need sleep or CONFIG_HOGPLUG_CPU.  However, I don't see major distros
> > shipping kernels to their server customers that way, so I didn't think
> > it would offend a significant part of the community's sense of freedom
> > if this config option were removed.  Maybe I was wrong.
> 
> distros aren't everything

Apparently a market for more config options of is alive and well.
Thank you for helping make the future of Linux more clear to me.

-Len
