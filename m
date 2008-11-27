Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbYK0OEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbYK0OEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYK0ODv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:03:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63137 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbYK0ODu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:03:50 -0500
Date: Thu, 27 Nov 2008 09:03:45 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Tim Bird <tim.bird@am.sony.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-branch-tracer: enhancements for the
 trace output
In-Reply-To: <c62985530811270511q2a3d86bcye4f90486624312e2@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0811270903230.18691@gandalf.stny.rr.com>
References: <492DEDE9.9010109@gmail.com> <20081127103424.GA9132@elte.hu>  <1227783300.4454.1410.camel@twins> <c62985530811270511q2a3d86bcye4f90486624312e2@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 27 Nov 2008, Fr?d?ric Weisbecker wrote:

> 2008/11/27 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> > On Thu, 2008-11-27 at 11:34 +0100, Ingo Molnar wrote:
> >> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >>
> >> > Here is an example of the new output:
> >> >
> >
> >> > CPU[000]  ------------8<---------- thread bash-2794 ------------8<----------
> >
> > This is the most horrid thing I've ever seen.
> >
> > Please just put the comm/pid in another left column and leave a plain
> > "---" string for context switches.
> >
> > comm/pid only in the separator is useless, you cannot grep stuff like
> > that, also, what's up with those '8's ?
> 
> 
> You don't like my ungreppable but cute scissors? :-)
> Yes, I will fix it.


scissors! Oh that's what they were!

;-)

-- Steve

