Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbYH3Ma7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbYH3Ma7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 08:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYH3Mau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 08:30:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53885 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbYH3Mau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 08:30:50 -0400
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger 2.6.27-rc5
	released
From: Peter Zijlstra <peterz@infradead.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: jmerkey@wolfmountaingroup.com, Robin Holt <holt@sgi.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080829155101.GA10954@khazad-dum.debian.net>
References: <200808290547.m7T5lgii016145@wolfmountaingroup.com>
	 <20080829105608.GG8555@sgi.com>
	 <55277.166.70.238.45.1220017673.squirrel@webmail.wolfmountaingroup.com>
	 <20080829155101.GA10954@khazad-dum.debian.net>
Content-Type: text/plain
Date: Sat, 30 Aug 2008 14:30:44 +0200
Message-Id: <1220099444.8426.29.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-29 at 12:51 -0300, Henrique de Moraes Holschuh wrote:
> On Fri, 29 Aug 2008, jmerkey@wolfmountaingroup.com wrote:
> > > Can this _PLEASE_ move to a different list?  I feel like these hourly
> > > spam postings of 30 patches is really getting excessive.  If people are
> > > interested in mdb, go to the mdb list or project page.
> > >
> > > Thanks,
> > > Robin
> > 
> > Every linux release is not hourly -- the last post was 7 days ago.   It
> > gets submitted for Andi and others to review the code, and it will be
> > submitted until Linus puts it into the kernel.   He needs to respond, not
> > one of his underlings.
> > 
> > I guess kdb downloads must be falling off or something.
> 
> Jeff, please post them all as a reply to a single, introductory message.
> That way, they get nicely grouped under that first introductory message, and
> anyone not interested can just delete the entire thread.
> 
> If you're using git, git send-email can do it for you.

Can this git send-email thing sanely thread these days? It used to be
that each next email was threaded to the next, creating these insanely
deep threads.

quilt mail threads all subsequent emails from the first mail, not from
the previous - a mode I much prefer.

