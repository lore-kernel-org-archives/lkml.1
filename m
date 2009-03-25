Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbZCYVLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbZCYVLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbZCYVK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:10:58 -0400
Received: from www.tglx.de ([62.245.132.106]:35466 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbZCYVK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:10:57 -0400
Date: Wed, 25 Mar 2009 22:09:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>
Subject: Re: [Announce] 2.6.29-rt1
In-Reply-To: <1238015156.2500.83.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0903252208440.3397@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>  <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>  <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain>  <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain> 
 <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain>  <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain>  <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain>  <alpine.LFD.2.00.0903201832590.29264@localhost.localdomain> 
 <alpine.LFD.2.00.0903231723090.29264@localhost.localdomain>  <alpine.LFD.2.00.0903252154040.3397@localhost.localdomain> <1238015156.2500.83.camel@ht.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009, Jaswinder Singh Rajput wrote:

> On Wed, 2009-03-25 at 21:59 +0100, Thomas Gleixner wrote:
> > We are pleased to announce the next update to our new preempt-rt
> > series.
> >  
> >      - port forward to 2.6.29 final
> > 
> > Download locations:
> > 
> >     http://rt.et.redhat.com/download/
> >     http://www.kernel.org/pub/linux/kernel/projects/rt/
> >  
> > Information on the RT patch can be found at:
> > 
> >     http://rt.wiki.kernel.org/index.php/Main_Page
> > 
> > to build the 2.6.29-rt1 tree, the following patches should be
> > applied:
> > 
> >     http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.29.tar.bz2
> 
> Is this valid ?

If we remove the testing/ it should work better :)

   tglx
