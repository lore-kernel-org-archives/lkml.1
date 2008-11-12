Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbYKLNBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbYKLNBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 08:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYKLNA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 08:00:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48604 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbYKLNA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 08:00:59 -0500
Date: Wed, 12 Nov 2008 08:00:57 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/2] unlikely profiler and tracer
In-Reply-To: <20081112105314.GB31958@elte.hu>
Message-ID: <alpine.DEB.1.10.0811120800140.2529@gandalf.stny.rr.com>
References: <20081112051438.843792214@goodmis.org> <20081112105314.GB31958@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 12 Nov 2008, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Ingo,
> > 
> > The following patches are in:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > 
> >     branch: tip/devel
> > 
> > Steven Rostedt (2):
> >       trace: profile likely and unlikely annotations
> >       ftrace: unlikely annotation tracer
> 
> i've created a new topic branch for this tracer: 
> tip/tracing/branch-tracer, and applied your patches to that branch. 

Good idea,

This profiler is very useful, but also very intrusive. I would like it to 
get a broader audience for testing.

-- Steve

