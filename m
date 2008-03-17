Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbYCQSUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbYCQSUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 14:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbYCQSUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 14:20:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:4308 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbYCQSUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 14:20:22 -0400
Message-ID: <47DEB65A.9080907@googlemail.com>
Date: Mon, 17 Mar 2008 19:20:10 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Gabriel C <crazy@frugalware.org>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
References: <200803170018.52663.rjw@sisk.pl> <47DDB969.1060200@googlemail.com> <alpine.LFD.1.00.0803171716130.3781@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0803171716130.3781@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 17 Mar 2008, Gabriel C wrote:
>>> Subject		: Clocksource tsc is always unstable with 2.6.25-* kernels and CONFIG_NO_HZ=y on my box
>>> Submitter	: Gabriel C <nix.or.die@googlemail.com>
>>> Date		: 2008-02-24 01:31 (22 days old)
>>> References	: http://lkml.org/lkml/2008/2/23/380
>>> 		  http://lkml.org/lkml/2008/2/24/281
>>> Handled-By	: Thomas Gleixner <tglx@linutronix.de>
>>>
>> Thomas do you want me to bisect ? 
> 
> That'd be great.

Ok I'll start doing that later on today.

> 
>> Or do you have any patches I could try ( really does not matter how experimental they are ) ?
> 
> No, I have not the lightest clue whats going on.
>  
> Thanks,
> 
> 	tglx
> 

Gabriel
