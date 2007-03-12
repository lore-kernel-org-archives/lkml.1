Return-Path: <linux-kernel-owner+w=401wt.eu-S932424AbXCLVlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbXCLVlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 17:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932489AbXCLVlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 17:41:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:59782 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932424AbXCLVly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 17:41:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18eous6f9se0mLUWdhcOlx493AgK6zm6RElk2ad1Q
	FX8shaSOFgDczs
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Mike Galbraith <efault@gmx.de>
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Cc: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <87zm6ijhq1.fsf@depni.sinp.msu.ru>
References: <200703111457.17624.kernel@kolivas.org>
	 <200703122223.07048.kernel@kolivas.org>
	 <1173710082.6326.49.camel@Homer.simpson.net>
	 <200703130549.47058.kernel@kolivas.org>
	 <1173730314.6431.30.camel@Homer.simpson.net>
	 <87zm6ijhq1.fsf@depni.sinp.msu.ru>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 22:41:44 +0100
Message-Id: <1173735704.7474.6.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 00:05 +0300, Serge Belyshev wrote:
> Mike Galbraith <efault@gmx.de> writes:
> 
> [snip]
> >> And let's not lose sight of things with this one testcase.
> >> 
> >> RSDL fixes
> >> - every starvation case
> >> - all fairness isssues
> >> - is better 95% of the time on the desktop
> >
> > I don't know where you got that 95% number from.  For the most part, the
> > existing scheduler does well.  If it sucked 95% of the time, it would
> > have been shredded a long time ago.
> >
> 
> I tell you.
> 
> http://article.gmane.org/gmane.linux.kernel/500027
> http://article.gmane.org/gmane.linux.kernel/502996
> http://article.gmane.org/gmane.linux.kernel/500119
> http://article.gmane.org/gmane.linux.kernel/500784
> http://article.gmane.org/gmane.linux.kernel/500768
> http://article.gmane.org/gmane.linux.kernel/502255
> http://article.gmane.org/gmane.linux.kernel/502282
> http://article.gmane.org/gmane.linux.kernel/503650
> http://article.gmane.org/gmane.linux.kernel/503695
> http://article.gmane.org/gmane.linux.kernel.ck/6512
> http://article.gmane.org/gmane.linux.kernel.ck/6539
> http://article.gmane.org/gmane.linux.kernel.ck/6565

Thanks, but I've already read them.  They are part of the reason I
decided to spend some time testing.

	-Mike

