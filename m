Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbYGFW2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbYGFW2l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 18:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYGFW2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 18:28:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752205AbYGFW2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 18:28:32 -0400
Date: Sun, 6 Jul 2008 15:27:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Domenico Andreoli <cavokz@gmail.com>
Subject: Re: 2.6.26-rc9: Reported regressions from 2.6.25
In-Reply-To: <20080706221932.GJ21669@cs181140183.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0807061524510.3016@woody.linux-foundation.org>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <200807062002.46863.rjw@sisk.pl> <20080706182648.GE21669@cs181140183.pp.htv.fi> <200807062304.07443.rjw@sisk.pl> <20080706213214.GH21669@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0807061443420.3016@woody.linux-foundation.org>
 <20080706221932.GJ21669@cs181140183.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Jul 2008, Adrian Bunk wrote:
>
> When did you tell me that maintainers should not or cannot be Cc'ed on 
> regression reports?

That is not what I'm complaining about.

I'm complaining about the fact that you *always* argue against closing 
bugreports.

You have argued against it for over a YEAR now. And every single time I 
tell you that you are wrong, and exactly *why* you are wrong.

If a reporter doesn't respond to say "it's still open", it needs to be 
closed. It doesn't matter one whit whether there has been developer action 
on it or not. We cannot keep old reports open - it's a total waste for 
developers to even _look_ at anything that is more than roughly a month 
old and hasn't been verified to be still be an issue.

			Linus
