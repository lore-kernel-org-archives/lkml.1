Return-Path: <linux-kernel-owner+w=401wt.eu-S1763576AbYD0XbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763576AbYD0XbT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbYD0XbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:31:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35795
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753342AbYD0XbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:31:08 -0400
Date: Sun, 27 Apr 2008 16:31:06 -0700 (PDT)
Message-Id: <20080427.163106.181887129.davem@davemloft.net>
To: mingo@elte.hu
Cc: James.Bottomley@HansenPartnership.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080427231809.GA13848@elte.hu>
References: <20080427214837.GA11631@elte.hu>
	<1209333959.3801.67.camel@localhost.localdomain>
	<20080427231809.GA13848@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 28 Apr 2008 01:18:09 +0200

> But, we'd not mind at all posting 1000 x86.git patches to lkml (or 
> another list) every 3 months (or more frequently), if people request 
> that.

Keep defending yourself Ingo.

You can post whatever patches you like a million times to lkml.
That's not the problem.

It's that the patches don't get reviewed, posting them more or to a
different place doesn't help that.

And you add patches before they are properly reviewed.

Look at all of the postings people have made this merge window about
x86 merge fallout(s).  This is exactly the chief gripe of everyone,
that you merge patches with little or no review into your tree.

People paying attention can see what your goal is.  You've expressed
in the past that you think we're not merging patches in fast enough,
which is quite a laugh, and now that you can do x86 maintainence
you're going to ramp things up and show everyone "how it's done."

And at what a great expense this experiment is being performed.  Just
ask anyone who has tried to get any work done this past week or so.
