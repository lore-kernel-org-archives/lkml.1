Return-Path: <linux-kernel-owner+w=401wt.eu-S932466AbXGXBVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466AbXGXBVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 21:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbXGXBUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 21:20:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49141 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753379AbXGXBUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 21:20:54 -0400
Date: Mon, 23 Jul 2007 18:20:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Rob Landley <rob@landley.net>, "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/7] lguest: documentation pt I: Preparation
Message-Id: <20070723182027.ebe04818.akpm@linux-foundation.org>
In-Reply-To: <1185238908.1803.63.camel@localhost.localdomain>
References: <1184980678.6344.1.camel@localhost.localdomain>
	<20070723171238.1a832b31.akpm@linux-foundation.org>
	<1185238908.1803.63.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007 11:01:48 +1000
Rusty Russell <rusty@rustcorp.com.au> wrote:

> > But I worry that you're proposing adding what appears to be new
> > Documentation-related machinery and infrastructure when there's already
> > increased activity in that area from other people and we might all be
> > headed in different directions and stuff.
> 
> It does add an lguest-specific script: I aimed for the minimal
> documentation script required to weave the code and documentation
> (basically extracts and orders by comment prefix, because code order
> isn't the same as optimal documentation order).
> 
> This is great for lguest, where the entire codebase is small and
> self-contained enough to be woven into a narrative, and the maintainer
> is prepared to put in the cycles to keep it uptodate.
> 
> But writing this documentation took *weeks*, to document 5000 lines of
> code.  Perhaps this effort, if merged, will inspire others, but I've
> seen little indication so far: we have enough trouble getting them
> documenting a single public function.

Yeah, I suspect there will be insufficient interest and energy for anyone
else to take this anywhere.

Could you please redo the changes after "link lguest example launcher
non-static", which made a fairly big mess?


