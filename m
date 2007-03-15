Return-Path: <linux-kernel-owner+w=401wt.eu-S933590AbXCOTz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590AbXCOTz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933604AbXCOTz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:55:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:52154 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933590AbXCOTz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:55:58 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, eranian@hpl.hp.com, rdunlap@xenotime.net
Subject: Re: [PATCH] i386: Simplify smp_call_function*() by using common implementation
References: <45F5FA97.8070705@goop.org>
	<20070315110805.262e1fa3.akpm@linux-foundation.org>
	<45F99B6F.9000604@goop.org>
	<20070315113301.5150a415.akpm@linux-foundation.org>
	<45F9A0E1.2080900@goop.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 15 Mar 2007 21:55:03 +0100
In-Reply-To: <45F9A0E1.2080900@goop.org>
Message-ID: <p73wt1i6xco.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Andrew Morton wrote:
> > Yup.  There is a huge and growing amount of outstanding x86 work.  As
> > always.  Developing against mainline is very optimistic.
> >   
> 
> Sigh.  Are you including Andi's patchset in -mm?  Should I rebase to
> -mm, or try to keep track of Andi's patchset?

I already got that patch, but haven't synced it out yet.

-Andi
