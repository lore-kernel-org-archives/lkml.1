Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbZKCPpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbZKCPpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:45:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbZKCPpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:45:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145AbZKCPpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:45:03 -0500
Date: Tue, 3 Nov 2009 07:43:02 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Marcel Holtmann <marcel@holtmann.org>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: Please consider reverting
 7d930bc33653d5592dc386a76a38f39c2e962344
In-Reply-To: <1257262588.3420.79.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0911030738260.31845@localhost.localdomain>
References: <20091103053156.GA3212@core.coreip.homeip.net>  <20091102.224957.32364226.davem@davemloft.net>  <20091103065238.GE3212@core.coreip.homeip.net>  <1257232587.3420.55.camel@localhost.localdomain>  <alpine.LFD.2.01.0911030719430.31845@localhost.localdomain>
 <1257262588.3420.79.camel@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Nov 2009, Marcel Holtmann wrote:
> 
> no questions that it needs fixed, I agree with you. However just blindly
> reverting something, because it fixes it for one or two people, might
> have side effects that causes more problems than the revert would
> actually fix.

Stop whining. Really.

Everybody understands that it should be fixed.  That's not the question.

But it should be fixed _quickly_. In this case, I have a bisection report 
FROM TWO DAYS AGO. And I'm still kicking myself for not just reverting 
that piece-of-shit commit then, because I spent the time to look at the 
oops and the commit, and could tell that it was crap.

Instead, I _did_ wait for the subsystem maintainer to get around to it. As 
a result of waiting, I've now wasted time for a lot of other people.

So stop your claptrap. You're wrong. I would suggest you now thank Dmitry, 
and ask his forgiveness for (a) wasting his time and (b) then berating him 
for it.

			Linus
