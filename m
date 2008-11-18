Return-Path: <linux-kernel-owner+w=401wt.eu-S1753784AbYKROST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbYKROST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 09:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbYKROSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 09:18:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57509 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbYKROSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 09:18:00 -0500
Date: Tue, 18 Nov 2008 09:17:58 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Noonan <steven@uplinklabs.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] tracing/ftrace: make nop tracer using tracer flags
In-Reply-To: <20081118101242.GL17838@elte.hu>
Message-ID: <alpine.DEB.1.10.0811180917100.15003@gandalf.stny.rr.com>
References: <4920D494.1010108@gmail.com> <f488382f0811161836n30ed40a7tcc9a32dac4b1c3ba@mail.gmail.com> <4920DE25.6050802@gmail.com> <20081118101242.GL17838@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 18 Nov 2008, Ingo Molnar wrote:

> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Steven Noonan a ?crit :
> > > I'd like these #defines and structs moved to just after the #includes,
> > > for cleanliness.
> > 
> > You're right I just corrected it in this V2.
> > 
> >  
> > > Other than the change noted above, I think it looks good.
> > > 
> > > Acked-by: Steven Noonan <steven@uplinklabs.net>
> > 
> > Thanks!
> > 
> > Here is the V2:
> 
> thanks.
> 
> Steve, what's your take on this method of allowing extensions to 
> tracer plugins? I've put Frederic's commits into tip/tracing/options, 
> but have not merged them into tip/master yet.

I'll pull it now and play with it to see if there's any issues I might 
find. But from looking at the patches, I do not see anything major.

I'll let you know.

-- Steve

