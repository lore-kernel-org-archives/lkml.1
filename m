Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbZISKEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbZISKEb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 06:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZISKEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 06:04:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51870 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbZISKEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 06:04:30 -0400
Date: Sat, 19 Sep 2009 12:04:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3][RESEND] tracing: remove max_tracer_type_len
Message-ID: <20090919100422.GD4160@elte.hu>
References: <4AB32364.7020602@cn.fujitsu.com> <4AB32377.9020601@cn.fujitsu.com> <1253281895.20020.326.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253281895.20020.326.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 2009-09-18 at 14:06 +0800, Li Zefan wrote:
> > Limit the length of a tracer's name within 100 chars, and then we
> > don't have to play with max_tracer_type_len.
> 
> What? You don't like my over-engineering? ;-)
> 
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Thanks, I'll pull them.
> 
> Ingo, This patch series is mainly cleanups. Do we still have time to 
> add this for v2.6.32, or should we wait till 33?.

Yeah, the tracing tree's been pretty good so far, i think we can do 
cleanups still.

	Ingo
