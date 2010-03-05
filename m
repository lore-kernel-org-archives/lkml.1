Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab0CEPTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:19:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753645Ab0CEPTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:19:03 -0500
Date: Fri, 5 Mar 2010 07:18:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: =?ISO-8859-15?Q?=22C=2E_Bergstr=F6m=22?= <cbergstrom@pathscale.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Ben Skeggs <skeggsb@gmail.com>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <4B90AFF3.3030100@pathscale.com>
Message-ID: <alpine.LFD.2.00.1003050714380.3788@localhost.localdomain>
References: <20100304103655.0b14343f@jbarnes-piketon> <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain> <20100304105624.70fe845e@jbarnes-piketon> <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain> <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>
 <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain> <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com> <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain> <1267748927.3496.6.camel@nisroch> <20100305064955.GA6453@elte.hu>
 <84144f021003042306w2e017efbva2be364c1c4980a7@mail.gmail.com> <4B90AFF3.3030100@pathscale.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Mar 2010, "C. Bergström" wrote:
>
> staging != stable

This really is being repeated, over and over. But it's irrelevant.

It's irrelevant because it's just a bad _excuse_.

That driver is used in production environments. That's _reality_. The 
whole "staging" thing is nothing more than a meaningless word.

And no, "staging" wasn't why it was merged. The reason it was merged was 
that very same "reality".

So every time somebody mentions staging as an argument, he's missing the 
whole effing point.

It also misses the point that the issues I've tried to bring up 
(bisection, testability) are real _technical_ arguments. Again, waving 
that "staging" flag is just stupid. It has nothing to do with the 
technical arguments, or with the reality of the situation. 

In other words, it's not just an excuse, it's a _meaningless_ excuse. It's 
a red herring. It's irrelevant to the issue.

			Linus
