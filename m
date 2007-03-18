Return-Path: <linux-kernel-owner+w=401wt.eu-S1750700AbXCRIe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750700AbXCRIe0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 04:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750708AbXCRIe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 04:34:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:34324 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750700AbXCRIeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 04:34:25 -0400
X-Provags-ID: V01U2FsdGVkX1/48KRF+p34RIv1zTArQuELbfQOXPF2gG6ezs0G/w
	mZ9lXB6sR365yU
Subject: Re: [ck] Re: RSDL v0.31
From: Mike Galbraith <efault@gmx.de>
To: jimmy bahuleyan <knight.camelot@gmail.com>
Cc: Radoslaw Szkodzinski <astralstorm@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>, Al Boldi <a1426z@gawab.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ck@vds.kolivas.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Nicholas Miell <nmiell@comcast.net>
In-Reply-To: <45FCF631.9020200@gmail.com>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703172048.46267.kernel@kolivas.org>
	 <1174125534.7734.2.camel@Homer.simpson.net>
	 <200703172355.30989.a1426z@gawab.com>
	 <1174198651.8199.44.camel@Homer.simpson.net>
	 <1174200463.10498.23.camel@localhost>
	 <1174201726.8732.6.camel@Homer.simpson.net>
	 <f44c5fdf0703180022n44b2ca61o62602e54aaab3334@mail.gmail.com>
	 <1174203482.8855.8.camel@Homer.simpson.net>  <45FCF631.9020200@gmail.com>
Content-Type: text/plain
Date: Sun, 18 Mar 2007 09:34:19 +0100
Message-Id: <1174206859.9098.6.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-18 at 13:50 +0530, jimmy bahuleyan wrote:

> maybe if it is possible to classify program behaviors that cause RSDL to
> do bad (relatively) or the mainline scheduler to jitter, we could try
> modifying the existing heuristics to get a better default scheduler.
> 
> of course, it wouldn't be able to cater to all the workloads and would
> meet everybody's definition of optimal. but getting close to optimal in
> most cases should be a good enough goal for linux's default sched!
> 
> i've been following this thread, and there's been many instances of
> 'RSDL is gr8' and 'RSDL regresses'.
> 
> maybe RSDL isn't the answer. maybe the current mainline sched isn't
> either. but RSDL definitely has done *something* right.

Agreed.

> What i think is needed is 'why this works here' and 'how to get this
> behavior to work with some other possibly conflicting but important
> workloads'.
> 
> (just my 2c :-)

IMHO, that's worth more than 2c.

	-Mike

