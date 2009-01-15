Return-Path: <linux-kernel-owner+w=401wt.eu-S1761196AbZAOKOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761196AbZAOKOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbZAOKOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:14:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44386 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbZAOKON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:14:13 -0500
Date: Thu, 15 Jan 2009 05:14:10 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tracing/ftrace: add missing unlock in
 register_stat_tracer()
In-Reply-To: <20090115100220.GF5833@elte.hu>
Message-ID: <alpine.DEB.1.10.0901150513500.716@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901142056470.22004@gandalf.stny.rr.com> <20090115100220.GF5833@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 15 Jan 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > Ingo,
> > 
> > The following patch is in:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > 
> >     branch: tip/devel
> > 
> > 
> > Li Zefan (1):
> >       tracing/ftrace: add missing unlock in register_stat_tracer()
> 
> hm, not there yet - forgot to push out?

Yep, sorry ;-)

Pushed, may take a few minutes to sync.

-- Steve

