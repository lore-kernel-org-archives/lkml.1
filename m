Return-Path: <linux-kernel-owner+w=401wt.eu-S1764351AbZANQ6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764351AbZANQ6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 11:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762845AbZANQ56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 11:57:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60622 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762379AbZANQ55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 11:57:57 -0500
Date: Wed, 14 Jan 2009 11:57:53 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: john stultz <johnstul@us.ibm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>, rostedt@home.goodmis.org,
       linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RT git pull] fixes for rt/sched
In-Reply-To: <496E12D3.80804@novell.com>
Message-ID: <alpine.DEB.1.10.0901141157040.15549@gandalf.stny.rr.com>
References: <20090114162226.13517.44371.stgit@dev.haskins.net> <496E12D3.80804@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 14 Jan 2009, Gregory Haskins wrote:

> [ Forgot to CC John the first time around ]
> 
> Gregory Haskins wrote:
> > The following changes since commit cfe6498c6a03e574bc9384cc95d73dfd20a13f05:
> >   Steven Rostedt (1):
> >         rt sched: add rt overload stats
> >
> > are available in the git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/linux-2.6-hacks.git rt/sched
> >
> > Gregory Haskins (1):
> >       rt/sched: ensure interrupts are disabled during post-schedule() processing
> >
> >  kernel/sched_rt.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> >


Thanks, applied.

(to git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-rt.git)

-- Steve

