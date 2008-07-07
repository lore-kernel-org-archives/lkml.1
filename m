Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbYGGT3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbYGGT3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 15:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbYGGT3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 15:29:16 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:34507 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627AbYGGT3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 15:29:15 -0400
Date: Mon, 7 Jul 2008 15:25:48 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       lkml List <linux-kernel@vger.kernel.org>
Subject: Re: Deputy maintainer for powerpc
Message-ID: <20080707152548.5075845f@zod.rchland.ibm.com>
In-Reply-To: <155B1079-39C4-4D15-B886-F904C424BC8C@kernel.crashing.org>
References: <18541.48403.490671.815858@cargo.ozlabs.ibm.com>
	<155B1079-39C4-4D15-B886-F904C424BC8C@kernel.crashing.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008 09:44:31 -0500
Kumar Gala <galak@kernel.crashing.org> wrote:

> 
> On Jul 4, 2008, at 1:02 AM, Paul Mackerras wrote:
> 
> > I'm going to be on vacation for the next two weeks, and it looks
> > highly likely that Linus will open the 2.6.27 merge window during that
> > time, so I'm appointing Ben Herrenschmidt as my deputy maintainer.
> > During the next two weeks, he'll be the person collecting together any
> > further powerpc-related commits that need to go upstream, and sending
> > pull requests to Linus as necessary.
> >
> > This is the start of a longer-term transition which will ultimately
> > result in me handing over the powerpc architecture maintainership to
> > Ben.  Because of various work commitments, this will be a gradual
> > transition taking probably around 6 months.
> >
> > Paul.
> 
> Ben, Do you have a tree that you'll be using to collect things in?

I hope it's the same tree for this merge window.

In the future, I hope the semantics of the various branches of the
new tree either stays the same, or comes with a detailed description of
what branch means what (assuming there is a new tree at some point).

josh
