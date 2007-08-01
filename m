Return-Path: <linux-kernel-owner+w=401wt.eu-S1763250AbXHASOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763250AbXHASOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbXHASOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:14:37 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4336 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbXHASOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:14:36 -0400
Date: Wed, 1 Aug 2007 20:14:44 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: <20070801174119.GA9152@elte.hu>
Message-ID: <Pine.LNX.4.64.0708012001280.1817@scrub.home>
References: <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0708010439050.1817@scrub.home> <20070801112229.GA11710@elte.hu>
 <Pine.LNX.4.64.0708011346510.1817@scrub.home> <20070801135949.GA10839@elte.hu>
 <Pine.LNX.4.64.0708011622400.1817@scrub.home> <20070801174119.GA9152@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 1 Aug 2007, Ingo Molnar wrote:

> > [...] I didn't say 'sleeper starvation' or 'rounding error', these are 
> > your words and it's your perception of what I said.
> 
> Oh dear :-) It was indeed my preception that yesterday you said:

*sigh* and here you go off again nitpicking on a minor issue just to prove 
your point...
When I wrote the earlier stuff I hadn't realized it was resolution 
related, so things have to be put into proper context and you make it 
yourself a little easy by equating them.
Yippi, you found another small error I made, can we drop this now? Please?

bye, Roman
