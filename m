Return-Path: <linux-kernel-owner+w=401wt.eu-S1763338AbYBBWGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763338AbYBBWGw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 17:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbYBBWGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 17:06:44 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36512 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753106AbYBBWGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:06:43 -0500
Date: Sat, 2 Feb 2008 14:06:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: x86: Why have __copy_from_user_ll_nocache* been exported?
Message-Id: <20080202140616.6566438d.akpm@linux-foundation.org>
In-Reply-To: <20080202213628.GJ9375@cs181133002.pp.htv.fi>
References: <20080131201430.GA9375@cs181133002.pp.htv.fi>
	<20080131130529.b0e17815.akpm@linux-foundation.org>
	<20080202213628.GJ9375@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Feb 2008 23:36:28 +0200 Adrian Bunk <bunk@kernel.org> wrote:

> On Thu, Jan 31, 2008 at 01:05:29PM -0800, Andrew Morton wrote:
> > On Thu, 31 Jan 2008 22:14:30 +0200
> > Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > > A commit that does nothing except for adding two unused EXPORT_SYMBOL's.
> > > 
> > > Without any rationale why they should be exported.
> > 
> > Don't look at me.  This has been sitting in my tree for nearly two years as
> > part of the reiser4 patchset.  It may not even be needed any more.  I guess
> > Ingo went on a fishing expedition and liked the change.
> >...
> 
> Sorry Andrew.
> 
> I misunderstood the patch flow.
> 
> And much more important, the tone of my email was not appropriate.
> 
> Due to unrelated reasons I was Thursday evening in a mood in which I 
> should not have left emails out of my postponed folder without sleeping 
> a night over them.

I know the feeling.

> I hope you accept my apology.

No probs.  But it's not really needed - this is lkml.  We shout at each
other, get over it and get on with stuff.
