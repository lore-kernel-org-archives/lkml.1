Return-Path: <linux-kernel-owner+w=401wt.eu-S1763607AbXFFRVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763607AbXFFRVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760283AbXFFRV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:21:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55318 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759483AbXFFRVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:21:23 -0400
Date: Wed, 6 Jun 2007 10:20:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       aaw@google.com, a.p.zijlstra@chello.nl
Subject: Re: 2.6.22-rc4-mm1
Message-Id: <20070606102031.bfab800e.akpm@linux-foundation.org>
In-Reply-To: <4666E678.4070608@fr.ibm.com>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	<4666ABD4.8050402@fr.ibm.com>
	<4666D050.7010603@googlemail.com>
	<4666DA55.5090405@fr.ibm.com>
	<20070606162649.GA9932@skynet.ie>
	<20070606163538.GN6909@holomorphy.com>
	<20070606164755.GA14278@skynet.ie>
	<4666E678.4070608@fr.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 18:53:12 +0200 Cedric Le Goater <clg@fr.ibm.com> wrote:

> Mel Gorman wrote:
> > On (06/06/07 09:35), William Lee Irwin III didst pronounce:
> >> On Wed, Jun 06, 2007 at 05:26:49PM +0100, Mel Gorman wrote:
> >>> I do not believe this is Nick's problem. I encountered the same issue and
> >>> the bisect ended up here;
> >>> # BISECT HERE
> >>> mm-variable-length-argument-support.patch
> >>> mm-variable-length-argument-support-fix.patch
> >>> # BISECT BAD
> >>> Reverting those two patches boots ok on my standalone x86 laptop.
> >>> Patch authors cc'd. I have not read the patches yet to see what might
> >>> be the problem.
> >> I found this a while ago and peterz already has a tentative fix for it at
> >> http://programming.kicks-ass.net/kernel-patches/max_arg_pages/move_anon_vma.patch
> >> I'm sure he himself will chime in with more/better code when he returns.
> >>
> > 
> > This patch also boots successfully on the machine.
> 
> Same for me.
> 

blah.  I dropped the whole lot.  Am shedding patches like leaves in autumn
at present.  Expect -mm2 RSN.

