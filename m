Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbYCQQSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbYCQQSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 12:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYCQQSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 12:18:15 -0400
Received: from www.tglx.de ([62.245.132.106]:59780 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbYCQQSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 12:18:14 -0400
Date: Mon, 17 Mar 2008 17:17:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Gabriel C <nix.or.die@googlemail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
In-Reply-To: <47DDB969.1060200@googlemail.com>
Message-ID: <alpine.LFD.1.00.0803171716130.3781@apollo.tec.linutronix.de>
References: <200803170018.52663.rjw@sisk.pl> <47DDB969.1060200@googlemail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2008, Gabriel C wrote:
> > Subject		: Clocksource tsc is always unstable with 2.6.25-* kernels and CONFIG_NO_HZ=y on my box
> > Submitter	: Gabriel C <nix.or.die@googlemail.com>
> > Date		: 2008-02-24 01:31 (22 days old)
> > References	: http://lkml.org/lkml/2008/2/23/380
> > 		  http://lkml.org/lkml/2008/2/24/281
> > Handled-By	: Thomas Gleixner <tglx@linutronix.de>
> > 
> 
> Thomas do you want me to bisect ? 

That'd be great.

> Or do you have any patches I could try ( really does not matter how experimental they are ) ?

No, I have not the lightest clue whats going on.
 
Thanks,

	tglx
