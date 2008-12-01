Return-Path: <linux-kernel-owner+w=401wt.eu-S1752920AbYLASQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbYLASQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 13:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbYLASPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 13:15:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55307 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbYLASPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 13:15:50 -0500
Date: Mon, 1 Dec 2008 13:15:47 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Milton Miller <miltonm@bga.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/5] powerpc: ftrace updates to previous patch series
In-Reply-To: <20081128131014.GC26793@elte.hu>
Message-ID: <alpine.DEB.1.10.0812011315020.7645@gandalf.stny.rr.com>
References: <20081126215821.263324391@goodmis.org> <alpine.DEB.1.10.0811261749310.1501@gandalf.stny.rr.com> <20081128131014.GC26793@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 28 Nov 2008, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Wed, 26 Nov 2008, Steven Rostedt wrote:
> > 
> > > Paul,
> > > 
> > > This patch series addresses the issues you brought up as well as
> > > adds some more enhancements and fixes. This series is added on
> > > top of the previous patch series.
> > > 
> > > The new patches are: (and are posted now)
> > > 5987225... powerpc/ppc32: static ftrace fixes for PPC32
> > 
> > The new commit id with the fix in Author and SoB is:
> > fd90db4bdc1ccf71927365cd634188cec4d7b151
> >  powerpc/ppc32: static ftrace fixes for 
> 
> Steve, you rebased the previous commits, and that's a no-no. I sorted it 
> all out, find below the stable URI for stuff that we'd like Paul to pull 
> shortly before the merge window.

Sorry, I rebased to edit the change log where I mispelled Paul's name.

-- Steve

