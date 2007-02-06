Return-Path: <linux-kernel-owner+w=401wt.eu-S1752037AbXBFPzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbXBFPzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 10:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbXBFPzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 10:55:16 -0500
Received: from mail.tmr.com ([64.65.253.246]:35132 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbXBFPzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 10:55:14 -0500
Message-ID: <45C8A4E9.9080304@tmr.com>
Date: Tue, 06 Feb 2007 10:55:21 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Mark Rustad <mrustad@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>  <20070205084523.GA21858@elte.hu>  <1170682488.29759.795.camel@pmac.infradead.org> <20070205155627.GA8354@elte.hu>  <1170692539.29759.856.camel@pmac.infradead.org> <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu>  <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>  <1170710272.29759.894.camel@pmac.infradead.org>  <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org>  <1170711587.29759.909.camel@pmac.infradead.org>  <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org>  <1170712393.29759.925.camel@pmac.infradead.org>  <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org>  <20070205143110.fca62b57.randy.dunlap@oracle.com>  <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org> <1170717694.29759.941.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051525320.8424@wood y.linux-foundation.org> <A77CFAF3-DFCF-44B5-8917-364D3498DB1A@gmail.com>
In-Reply-To: <A77CFAF3-DFCF-44B5-8917-364D3498DB1A@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Rustad wrote:
> On Feb 5, 2007, at 5:32 PM, Linus Torvalds wrote:
> 
> <snip>
> 
>> And I told you that you could just improve the tools that track those
>> dependencies ANYWAY!
> 
> They aren't that bad even now. Using menuconfig (I'm a fossil that just 
> uses curses for most things), hitting ? shows what depends or selects 
> any particular entry. That is good enough for me now. Maybe I am just 
> willing to ask for help, but the help already seems to be there.
> 
I think the problem Linus referenced with not even seeing an option is 
an issue, you can't "?" on an option you can't see. An I use menuconfig 
also, from long habit (accessing a remote compile server with slow dialup).

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
