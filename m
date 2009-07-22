Return-Path: <linux-kernel-owner+w=401wt.eu-S1752620AbZGVPQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbZGVPQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZGVPQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:16:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42117 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbZGVPQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:16:08 -0400
Date: Wed, 22 Jul 2009 11:16:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/events: Add module tracepoints
In-Reply-To: <4A66C468.5070100@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907221115020.1059@gandalf.stny.rr.com>
References: <4A6582C1.2040609@cn.fujitsu.com> <200907221352.17850.rusty@rustcorp.com.au> <4A66C468.5070100@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 22 Jul 2009, Li Zefan wrote:

> Rusty Russell wrote:
> > On Tue, 21 Jul 2009 06:26:33 pm Li Zefan wrote:
> >> Add trace points to trace module_load, module_free, module_get,
> >> module_put and module_request, and use trace_event facility
> >> to get the trace output.
> > 
> > Hi Li Zefan,
> > 
> >    I don't know anything about tracing, but the module code changes look
> > simple and fine to me.
> > 
> 
> I guess I can take this as an ack. :)

I'll take it as an ack too ;-)

> 
> Tracing is used to have a deep insight into the system, analyse
> performance issue, help debugging, dump info at system panic,
> etc..

Looks good. I'm currently doing some maintenance on my systems, but once 
that is done, I'll go ahead and queue up your patches.

Thanks,

-- Steve

