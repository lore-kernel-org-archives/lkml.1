Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbZLIF5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbZLIF5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 00:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbZLIF45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 00:56:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44113 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086AbZLIF44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 00:56:56 -0500
Date: Wed, 9 Dec 2009 06:56:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Carsten Emde <Carsten.Emde@osadl.org>,
       Olof Johansson <olof@lixom.net>, hpa@zytor.com, tglx@linutronix.de
Subject: Re: [PATCH][GIT PULL][v2.6.33] tracing: Remove comparing of NULL to
 va_list in trace_array_vprintk()
Message-ID: <20091209055602.GB2512@elte.hu>
References: <4B01AE5D.1010801@osadl.org>
 <tip-c13d2f7c3231e873f30db92b96c8caa48f100f33@git.kernel.org>
 <20091206051352.GA4628@lixom.net>
 <4B1BAB74.104@osadl.org>
 <1260332397.2146.38.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260332397.2146.38.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Hi Ingo,
> 
> This is an urgent fix that fixes a ARM build breakage. It is based on
> the last pull request I had that fixes the function graph tracer output.
> 
> 
> Ingo,
> 
> Please pull the latest tip/tracing/core2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core2
> 
> 
> Carsten Emde (1):
>       tracing: Remove comparing of NULL to va_list in trace_array_vprintk()
> 
> ----
>  kernel/trace/trace.c |   18 ++++++++++++------
>  1 files changed, 12 insertions(+), 6 deletions(-)

Pulled, thanks Steve!

	Ingo
