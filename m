Return-Path: <linux-kernel-owner+w=401wt.eu-S933109AbXGKVzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109AbXGKVzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765623AbXGKVzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:55:08 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55600 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765546AbXGKVzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:55:07 -0400
Date: Wed, 11 Jul 2007 14:54:12 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Valdis.Kletnieks@vt.edu
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
Message-ID: <20070711215412.GZ4306@sequoia.sous-sol.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> <20070711211638.GE18767@one.firstfloor.org> <28188.1184190381@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28188.1184190381@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu) wrote:
> On Wed, 11 Jul 2007 23:16:38 +0200, Andi Kleen said:
> (Note - I'm just a usually-confused crash test dummy here...)
> 
> > Well I spent a lot of time making the x86-64 timing code work
> > well on a variety of machines; working around a wide variety
> > of hardware and platform bugs. I obviously don't agree on your description
> > of its maintenance state. 
> 
> I'm seeing a bit of a disconnect here.  If you spent all that time making it
> work, how come the guys who developed the patch are saying you didn't provide
> any feedback about the patchset?

I think Andi's referring to the existing x86_64 code, which gets
replaced by the patchset in question.
