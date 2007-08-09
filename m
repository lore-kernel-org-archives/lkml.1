Return-Path: <linux-kernel-owner+w=401wt.eu-S938915AbXHIJTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938915AbXHIJTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935108AbXHIJT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:19:27 -0400
Received: from 207.47.19.6.static.nextweb.net ([207.47.19.6]:40334 "EHLO
	ex1.resilience.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934808AbXHIJTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:19:25 -0400
Date: Thu, 9 Aug 2007 17:18:32 +0800
From: Jerry Jiang <wjiang@resilience.com>
To: 7eggert@gmx.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, akpm@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       cfriesen@nortel.com, zlynx@acm.org
Subject: Re: [PATCH] make atomic_t volatile on all architectures
Message-Id: <20070809171832.1568864b.wjiang@resilience.com>
In-Reply-To: <E1IJ424-0000d7-HK@be1.lrz>
References: <8Q2Pg-8uV-23@gated-at.bofh.it>
	<8Q7Fa-7rJ-1@gated-at.bofh.it>
	<8Q8rD-hh-7@gated-at.bofh.it>
	<E1IJ424-0000d7-HK@be1.lrz>
Organization: Resilience
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Aug 2007 09:19:12.0640 (UTC) FILETIME=[597F9000:01C7DA66]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Aug 2007 11:10:16 +0200
Bodo Eggert <7eggert@gmx.de> wrote:

> > 
> > Why the *volatile-accesses-in-code* is acceptable, does C standard make it
> > clear?
> 
> http://lwn.net/Articles/233482/

I have read this article before, but What Linus said only focusing on
the conclusion-- The semantics of it are so unclear as
to be totally useless.

and still not to said "Why the *volatile-accesses-in-code* is
acceptable"

-- Jerry


> -- 
> Fun things to slip into your budget
> Heisenberg Compensator upgrade kit
> 
> Friß, Spammer: uWfuXeviZ@x.7eggert.dyndns.org
