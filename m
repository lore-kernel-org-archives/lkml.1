Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbZLHNZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbZLHNZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 08:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbZLHNZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 08:25:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33493 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbZLHNZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 08:25:15 -0500
X-Authority-Analysis: v=1.0 c=1 a=P1cUn18sqUUA:10 a=9qwtHndI238-nIwfTGgA:9 a=a9cn6air1dAd9yOQHbsA:7 a=1EGv65lJCZrkiRuBc0HqYdQ5_qMA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 01/13] tracing: Extract duplicate
 ftrace_raw_init_event_foo()
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B1E0509.5070102@cn.fujitsu.com>
References: <4B1DC476.3030700@cn.fujitsu.com>
	 <4B1DC48C.7080603@cn.fujitsu.com> <20091208073042.GA4989@nowhere>
	 <4B1E0509.5070102@cn.fujitsu.com>
Content-Type: text/plain
Date: Tue, 08 Dec 2009 08:23:36 -0500
Message-Id: <1260278616.2165.19.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 15:49 +0800, Li Zefan wrote:

> > 
> > Nice cleanup.
> > BTW, init_syscall_trace is left unused now. Could you please
> > remove it too?
> > 
> 
> I'd like to see the whole patchset be accepted first. I don't
> won't to spam LKML with another 14 emails. ;)

Yeah, I agree. The removing of that can be a later patch.

I'll allocate time today to review this series, and if I don't come up
with anything major, I'll pull it in.

Thanks!

-- Steve

> 
> Though I can just resend this patch, Ingo might be confused
> which patch he should take.
> 
> btw, Lai Jiangshan just told me he has a pending patch that
> will modify init_syscall_trace, so init_syscall_trace will
> come back to use again.
> 
> > And add my Acked-by. Thanks!
> > 
> 
> Thanks!

