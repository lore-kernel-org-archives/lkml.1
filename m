Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbZKCQIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbZKCQIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 11:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbZKCQII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 11:08:08 -0500
Received: from senator.holtmann.net ([87.106.208.187]:40192 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbZKCQIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 11:08:06 -0500
Subject: Re: Please consider reverting
 7d930bc33653d5592dc386a76a38f39c2e962344
From: Marcel Holtmann <marcel@holtmann.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <alpine.LFD.2.01.0911030738260.31845@localhost.localdomain>
References: <20091103053156.GA3212@core.coreip.homeip.net>
	 <20091102.224957.32364226.davem@davemloft.net>
	 <20091103065238.GE3212@core.coreip.homeip.net>
	 <1257232587.3420.55.camel@localhost.localdomain>
	 <alpine.LFD.2.01.0911030719430.31845@localhost.localdomain>
	 <1257262588.3420.79.camel@localhost.localdomain>
	 <alpine.LFD.2.01.0911030738260.31845@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 04 Nov 2009 01:08:05 +0900
Message-Id: <1257264485.3420.87.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> > no questions that it needs fixed, I agree with you. However just blindly
> > reverting something, because it fixes it for one or two people, might
> > have side effects that causes more problems than the revert would
> > actually fix.
> 
> Stop whining. Really.
> 
> Everybody understands that it should be fixed.  That's not the question.
> 
> But it should be fixed _quickly_. In this case, I have a bisection report 
> FROM TWO DAYS AGO. And I'm still kicking myself for not just reverting 
> that piece-of-shit commit then, because I spent the time to look at the 
> oops and the commit, and could tell that it was crap.
> 
> Instead, I _did_ wait for the subsystem maintainer to get around to it. As 
> a result of waiting, I've now wasted time for a lot of other people.

I do have a patch in my inbox from Johannes from 4 days ago that fixes
this issue.

	http://marc.info/?l=linux-wireless&m=125697124819563&w=2

So what is the take away from this now? Do you wanna have Johannes step
over John and Dave and send such a patch directly to you?

Regards

Marcel


