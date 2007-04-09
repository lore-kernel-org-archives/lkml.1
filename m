Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbXDITL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbXDITL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 15:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbXDITL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 15:11:27 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:46400 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbXDITL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 15:11:26 -0400
Message-ID: <461A8F83.90107@gmail.com>
Date: Mon, 09 Apr 2007 21:09:55 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mike Galbraith <efault@gmx.de>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ten percent test
References: <200703290237.38777.kernel@kolivas.org> <200704071423.47790.gene.heskett@gmail.com> <20070407185220.GA31725@elte.hu> <200704071630.25830.gene.heskett@gmail.com> <20070408104125.GB11123@elte.hu> <461939A4.2020305@gmail.com> <1176092598.6355.22.camel@Homer.simpson.net> <461A2E39.8060106@gmail.com> <20070409141516.GB11244@elte.hu> <461A7246.60003@gmail.com> <20070409174803.GA10189@elte.hu>
In-Reply-To: <20070409174803.GA10189@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2007 07:48 PM, Ingo Molnar wrote:

> i didnt say that, in fact my first lkml comment about RSDL on lkml
> was the exact opposite, but you SD advocates are _still_ bickering
> about (and not accepting) fundamental things like Mike's make -j5
> workload and flagging it as unrealistic, so until there's so much
> reality disconnect there's not much chance for this issue to progress
> i'm afraid.

I suppose I'm lumped in with the "SD advocates" now but you will note 
that I haven't been bickering about make -j5 loads. You cut away the 
entire meat of my reply which was all that predictability harping.

What I did say about make -j5 loads is that I do not think that they, 
under all circumstances, on all machines and at all cost, need to 
perform the same as currently if other situations improve. Do I want 
heuristics? Sure, I'm just saying the kernel is fundamentally incapable 
of getting it right all of the time and as such it should provide me 
with as many opportunities as possible at stepping in. That is, let me 
understand what it is and is going to be doing and then listen to me.

I agree not a lot of progress is to be made if people keep ignoring each 
other like that but also while SD's author is offline. Let's just shelve 
it until he's back. Not bury though...

Rene.

