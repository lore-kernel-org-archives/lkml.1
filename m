Return-Path: <linux-kernel-owner+w=401wt.eu-S1762718AbXIZV1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762718AbXIZV1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761095AbXIZV1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:27:22 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:40137 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757445AbXIZV1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:27:21 -0400
Date: Wed, 26 Sep 2007 17:27:04 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: v2.6.23-rc4-rt1 / new project URL
In-Reply-To: <1190841410.18147.41.camel@lappy>
Message-ID: <Pine.LNX.4.58.0709261726440.6803@gandalf.stny.rr.com>
References: <1188593944.9647.15.camel@chaos>  <1189427714.21778.15.camel@twins>
 <1190841410.18147.41.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--

On Wed, 26 Sep 2007, Peter Zijlstra wrote:

> On Mon, 2007-09-10 at 14:35 +0200, Peter Zijlstra wrote:
> > > A bunch of patches are postponed for -rt2 (they are neither ignored
> > > nor forgotten):
> > >
> > > - simple_irq change (Kevin Hilman): needs more thought
> > > - RCU updates (Paul McKenney): needs proper integration
> > > - latency tracer changes (Daniel Walker): needs review
> > > - PICK_OP changes (Daniel Walker): needs review
> >
> > This one seems to have slipped through the cracks:
> >   http://lkml.org/lkml/2007/8/16/135
>
> Seems to be missed again :-/
>

Will work on that tonight.

-- Steve

