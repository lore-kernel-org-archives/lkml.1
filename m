Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbZCLNje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbZCLNje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbZCLNjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:39:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43414 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994AbZCLNjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:39:23 -0400
Date: Thu, 12 Mar 2009 09:39:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pierre Ossman <drzeus@drzeus.cx>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Pekka Paalanen <pq@iki.fi>,
       Neil Horman <nhorman@redhat.com>
Subject: Re: [PATCH 0/4] [GIT PULL] memory saving ring buffer for
 tip/tracing/ftrace
In-Reply-To: <20090312102014.7271f54e@mjolnir.ossman.eu>
Message-ID: <alpine.DEB.2.00.0903120939000.3062@gandalf.stny.rr.com>
References: <20090312023720.144716747@goodmis.org> <20090312080758.4a14d5b4@mjolnir.ossman.eu> <20090312163414.43B4.A69D9226@jp.fujitsu.com> <20090312102014.7271f54e@mjolnir.ossman.eu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 12 Mar 2009, Pierre Ossman wrote:

> On Thu, 12 Mar 2009 16:34:55 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > How difficult is it to apply this to 2.6.27? Fedora is still on that
> > > kernel and it would be nice if I could get my memory back on a
> > > distribution kernel. :)
> > 
> > Difficult.
> > but you can use "trace_entries=1" kernel boot parameter :)
> > 
> 
> Ah. I got a tip for trace_buf_size=1, but that didn't work. Your
> version was much better. :)

Yeah, the name changed within the versions.

-- Steve

