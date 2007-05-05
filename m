Return-Path: <linux-kernel-owner+w=401wt.eu-S376173AbXEEB4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376173AbXEEB4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 21:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376170AbXEEB4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 21:56:31 -0400
Received: from ozlabs.org ([203.10.76.45]:32787 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S376171AbXEEB4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 21:56:30 -0400
Subject: Re: [PATCH] Revert "[PATCH] paravirt: Add startup infrastructure
	for paravirtualization"
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070504085818.2762b160.akpm@linux-foundation.org>
References: <m1mz0ku7je.fsf@ebiederm.dsl.xmission.com>
	 <1178280770.23670.61.camel@localhost.localdomain>
	 <m1y7k4smmo.fsf@ebiederm.dsl.xmission.com>
	 <1178289450.23670.100.camel@localhost.localdomain>
	 <20070504085818.2762b160.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 05 May 2007 11:55:51 +1000
Message-Id: <1178330151.12284.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 08:58 -0700, Andrew Morton wrote:
> On Sat, 05 May 2007 00:37:30 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > Of course, I expect that Andrew is about to push my patches to Linus....
> > any day now... right Andrew?  Then we don't need this argument.
> 
> It would be about a week off.  I'll resend the paches out for rereview.

Unfortunately, it's becoming clear that we need to know what's going to
happen with the boot code first.  The details are both nasty and
important.

Hopefully this will all occur in the next few days so we can put
something small in w/o blocking lguest.  But if not, so be it: at least
we're making progress.

Sorry,
Rusty.

