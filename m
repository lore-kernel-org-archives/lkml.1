Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbXGOVLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbXGOVLT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 17:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXGOVLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 17:11:09 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:43537 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbXGOVLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 17:11:08 -0400
From: Markus <lists4me@web.de>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [patch] CFS scheduler, -v19
Date: Sun, 15 Jul 2007 23:11:04 +0200
User-Agent: KMail/1.9.5
Cc: Ed Tomlinson <edt@aei.ca>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20070706173319.GA2356@elte.hu> <200707151453.57725.lists4me@web.de> <1184528791.6324.41.camel@Homer.simpson.net>
In-Reply-To: <1184528791.6324.41.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707152311.05286.lists4me@web.de>
X-Provags-ID: V01U2FsdGVkX1+U57KCBOTF7hVJp2MefvncX6vsGfSnvVao8Uua
	vvB1mE5y3va55IdDuXc2YRNxsnIXfO4wk9eC2A5f//t0HLJj9v
	NlqwQZxdw=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > [1] http://lkml.org/lkml/2007/07/14/60
> 
> Hm.  Tasks disappearing isn't you're typical process scheduler problem
> by any means, nor is an idle box exhibiting mouse "lurchiness".  Is
> there anything unusual in your logs?

I know that its not typical, but when my current kernel is stable and 
shows the same problem with the cfs-patch applied like the 
git-snapshot, I would say its a cfs issue.
There is nothing in the logs when a program dies, thats why asked for a 
way to make the kernel more verbose.
But I can build a plain 2.6.22 without cfs and one with it and compare 
dmesgs output, if that helps.

   Markus
