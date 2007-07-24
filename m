Return-Path: <linux-kernel-owner+w=401wt.eu-S1762761AbXGXBk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762761AbXGXBk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 21:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbXGXBkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 21:40:17 -0400
Received: from ozlabs.org ([203.10.76.45]:40102 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825AbXGXBkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 21:40:16 -0400
Subject: Re: [PATCH 1/7] lguest: documentation pt I: Preparation
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Rob Landley <rob@landley.net>, "Randy.Dunlap" <rdunlap@xenotime.net>
In-Reply-To: <20070723182027.ebe04818.akpm@linux-foundation.org>
References: <1184980678.6344.1.camel@localhost.localdomain>
	 <20070723171238.1a832b31.akpm@linux-foundation.org>
	 <1185238908.1803.63.camel@localhost.localdomain>
	 <20070723182027.ebe04818.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 11:39:47 +1000
Message-Id: <1185241187.1803.82.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 18:20 -0700, Andrew Morton wrote:
> On Tue, 24 Jul 2007 11:01:48 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:
> > But writing this documentation took *weeks*, to document 5000 lines of
> > code.  Perhaps this effort, if merged, will inspire others, but I've
> > seen little indication so far: we have enough trouble getting them
> > documenting a single public function.
> 
> Yeah, I suspect there will be insufficient interest and energy for anyone
> else to take this anywhere.
> 
> Could you please redo the changes after "link lguest example launcher
> non-static", which made a fairly big mess?

Indeed... which is why I was waiting to see if it got into Linus' tree
(I sent it before rc1, but too late now).

I'm waiting until Linus says he'll apply my documentation patches, then
I'll rejig that patch...

Thanks,
Rusty.

