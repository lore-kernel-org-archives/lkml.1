Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab0CMV4L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 16:56:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:54890 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238Ab0CMV4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 16:56:05 -0500
Date: Sat, 13 Mar 2010 22:56:00 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Jiri Slaby <jirislaby@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Writable limits (was Re: Linux 2.6.34-rc1)
In-Reply-To: <4B9574EB.3080303@gmail.com>
Message-ID: <alpine.LRH.2.00.1003132252160.12517@twin.jikos.cz>
References: <alpine.LFD.2.00.1003081204510.3669@localhost.localdomain> <4B9574EB.3080303@gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Mar 2010, Jiri Slaby wrote:

> > It's out there now. I still have a few trees I already got pull requests 
> > for, and that I want to look over a bit more (ceph, gdb tree etc), and 
> > it's possible that I've just overlooked some other pull request.
> > 
> > So if you feel like you sent me a pull request bit might have been 
> > over-looked, please point that out to me
> 
> Hi, yes, the writable limits tree:
> http://lkml.org/lkml/2010/3/5/219
> 
> Maybe it was ignored on purpose. Either way, I would like to know to
> decide whether to drop it from -next or not and wait for a 2.6.35 merge
> window.

Seems like this was neither commented on, nor merged. I don't see any 
serious objections to having this merged having been raised anywhere ...

Any word on this?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
