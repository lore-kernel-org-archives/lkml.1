Return-Path: <linux-kernel-owner+w=401wt.eu-S1752931AbXCLVFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbXCLVFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 17:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbXCLVFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 17:05:14 -0400
Received: from depni.sinp.msu.ru ([213.131.7.21]:55934 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbXCLVFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 17:05:13 -0400
To: Mike Galbraith <efault@gmx.de>
Cc: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
References: <200703111457.17624.kernel@kolivas.org>
	<200703122223.07048.kernel@kolivas.org>
	<1173710082.6326.49.camel@Homer.simpson.net>
	<200703130549.47058.kernel@kolivas.org>
	<1173730314.6431.30.camel@Homer.simpson.net>
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Date: Tue, 13 Mar 2007 00:05:10 +0300
In-Reply-To: <1173730314.6431.30.camel@Homer.simpson.net> (Mike Galbraith's message of "Mon\, 12 Mar 2007 21\:11\:54 +0100")
Message-ID: <87zm6ijhq1.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.0 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith <efault@gmx.de> writes:

[snip]
>> And let's not lose sight of things with this one testcase.
>> 
>> RSDL fixes
>> - every starvation case
>> - all fairness isssues
>> - is better 95% of the time on the desktop
>
> I don't know where you got that 95% number from.  For the most part, the
> existing scheduler does well.  If it sucked 95% of the time, it would
> have been shredded a long time ago.
>

I tell you.

http://article.gmane.org/gmane.linux.kernel/500027
http://article.gmane.org/gmane.linux.kernel/502996
http://article.gmane.org/gmane.linux.kernel/500119
http://article.gmane.org/gmane.linux.kernel/500784
http://article.gmane.org/gmane.linux.kernel/500768
http://article.gmane.org/gmane.linux.kernel/502255
http://article.gmane.org/gmane.linux.kernel/502282
http://article.gmane.org/gmane.linux.kernel/503650
http://article.gmane.org/gmane.linux.kernel/503695
http://article.gmane.org/gmane.linux.kernel.ck/6512
http://article.gmane.org/gmane.linux.kernel.ck/6539
http://article.gmane.org/gmane.linux.kernel.ck/6565


Also, count my email too.
I'm using RSDL since day one on my laptop and my router/compute server
and I wont come back to mainline, needless to say why.
