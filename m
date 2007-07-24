Return-Path: <linux-kernel-owner+w=401wt.eu-S934567AbXGXBTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934567AbXGXBTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 21:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbXGXBT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 21:19:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33347 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761395AbXGXBTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 21:19:24 -0400
Date: Mon, 23 Jul 2007 18:18:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Rob Landley <rob@landley.net>, "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/7] lguest: documentation pt I: Preparation
In-Reply-To: <1185238908.1803.63.camel@localhost.localdomain>
Message-ID: <alpine.LFD.0.999.0707231808560.3607@woody.linux-foundation.org>
References: <1184980678.6344.1.camel@localhost.localdomain> 
 <20070723171238.1a832b31.akpm@linux-foundation.org>
 <1185238908.1803.63.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jul 2007, Rusty Russell wrote:
> 
> Indeed, no code changes, and I feel strongly that it should go into
> 2.6.23 because it's *fun*.   And (as often complained) there's not
> enough poetry in the kernel.

There's a reason for that.

	There once was a lad from Braidwood
	With a wife and a hatred for FUD
	  He hacked kernels for fun,
	  couldn't get them to run.
	But he always felt that he should.

See?

So when you say "there's not enough poetry", next time you'll know why. 
You *really* don't want want poetry.

		Linus

PS. Nothing rhymes with Ballalaba.
