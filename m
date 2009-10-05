Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbZJEVvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbZJEVvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 17:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbZJEVvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 17:51:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49148 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699AbZJEVvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 17:51:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull request] ACPI Processor Aggregator Driver for 2.6.32-rc1
Date: Mon, 5 Oct 2009 23:51:53 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-rjw; KDE/4.3.1; x86_64; ; )
Cc: balbir@linux.vnet.ibm.com, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Shaohua Li <shaohua.li@intel.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
References: <alpine.LFD.2.00.0910030145140.25240@localhost.localdomain> <200910052159.24920.rjw@sisk.pl> <alpine.LFD.2.01.0910051354450.3432@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910051354450.3432@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910052351.53207.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 October 2009, Linus Torvalds wrote:
> 
> On Mon, 5 Oct 2009, Rafael J. Wysocki wrote:
> > 
> > This thing has already been merged, it appears: and it looks like a 
> > total breakage of rules to me.
> 
> Well, Len pointed out to me that the NAK is kind of pointless, since it 
> had no constructive alternatives to the issue. So he left it in as 
> documentation, but until the scheduler people can actually _do_ something 
> about the problem, their voice doesn't really matter, does it?

Well, for a patch that was objected to so strongly, I think it didn't get
enough review from other relevant people before being pushed upstream.
It looks like Balbir didn't see it before for one example.

It's been lots of time since the patch was originally posted to send it to
the LKML for discussion and so on and to receive some comments that
might help to improve it.  I have no idea why that wasn't done and I suspect
there was some corporate pressure on Len to push it upstream as quickly as
possible.

Best,
Rafael
