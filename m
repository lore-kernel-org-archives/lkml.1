Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbXEDOhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbXEDOhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbXEDOhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:37:52 -0400
Received: from ozlabs.org ([203.10.76.45]:39550 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359AbXEDOhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:37:51 -0400
Subject: Re: [PATCH] Revert "[PATCH] paravirt: Add startup infrastructure
	for paravirtualization"
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <m1y7k4smmo.fsf@ebiederm.dsl.xmission.com>
References: <m1mz0ku7je.fsf@ebiederm.dsl.xmission.com>
	 <1178280770.23670.61.camel@localhost.localdomain>
	 <m1y7k4smmo.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Sat, 05 May 2007 00:37:30 +1000
Message-Id: <1178289450.23670.100.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 08:13 -0600, Eric W. Biederman wrote:
> We don't have any working code, there are no in tree users.

Hi Eric,

	Lack of in-tree code is definitely not due to me.  The code which uses
it has been sitting in -mm for three months.  Suddenly ripping this out
and breaking all that work without replacing it is rude.

> Therefore the code should go.

Then put the patch is -mm, behind lguest.  Or better, help me refine my
patches and I'll happily do it for you.

Of course, I expect that Andrew is about to push my patches to Linus....
any day now... right Andrew?  Then we don't need this argument.

Rusty.


