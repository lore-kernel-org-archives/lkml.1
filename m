Return-Path: <linux-kernel-owner+w=401wt.eu-S1758889AbZBFO7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889AbZBFO7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755928AbZBFO73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:59:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64444 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbZBFO72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:59:28 -0500
Date: Fri, 6 Feb 2009 09:59:26 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 2/4] nmi: add generic nmi tracking state
In-Reply-To: <20090206145431.GG18368@elte.hu>
Message-ID: <alpine.DEB.1.10.0902060956480.10059@gandalf.stny.rr.com>
References: <20090206065352.940088243@goodmis.org> <20090206065437.986292747@goodmis.org> <1233912891.4731.1.camel@laptop> <20090206144609.GB18368@elte.hu> <alpine.DEB.1.10.0902060950250.10059@gandalf.stny.rr.com> <20090206145431.GG18368@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 6 Feb 2009, Ingo Molnar wrote:
> > Is it OK to rebase the branch to do so?
> 
> Sure, that's necessary.

OK, will do.

> 
> And note that unless you base your tree against tip:tracing/ftrace i cannot 
> do a straight pull anyway. (your trees are usually based against tip:master 
> - which brings in all other branches)

Which is better for you? Should I base it off of tracing/ftrace instead? I 
just been using master to make sure I did not break anything else in your 
repo ;-)

I can set up a branch called tip/ftrace/devel that will be based off of 
tracing/ftrace, and keep tip/devel off of tip/master. This will let
you know which repo my post is based off of. I'll also add it to the 
subject.

-- Steve

