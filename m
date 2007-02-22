Return-Path: <linux-kernel-owner+w=401wt.eu-S1751354AbXBVAU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354AbXBVAU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 19:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbXBVAU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 19:20:29 -0500
Received: from ns2.suse.de ([195.135.220.15]:41763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbXBVAU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 19:20:28 -0500
Date: Thu, 22 Feb 2007 02:19:30 +0100
From: Andi Kleen <ak@suse.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 00/21] 2.6.19-stable review
Message-ID: <20070222011930.GH12472@bingen.suse.de>
References: <20070221013619.GA30227@kroah.com> <45DC9E1D.40805@redhat.com> <20070221114737.a09be761.akpm@linux-foundation.org> <20070221222042.GG12472@bingen.suse.de> <45DCCA05.3030903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DCCA05.3030903@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 05:39:01PM -0500, Chuck Ebbert wrote:
> Andi Kleen wrote:
> >>> What is the status of:
> >>>
> >>> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/x86_64-mm-simplfy-__assign_irq_vector.patch
> >>> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/x86_64-mm-handle-irqs-pending-in-irr-during-irq-migration.patch
> >> That's mainly an Andi decision.  Let's cc him.
> > 
> > I didn't think the problem was serious enough for a backport. Do we have
> > user reports? 
> 
> Yes, lots:
> 
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=225399

Ok for me then.

-Andi
