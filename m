Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbXENUAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbXENUAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbXENUAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:00:05 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755349AbXENUAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:00:01 -0400
Date: Mon, 14 May 2007 12:59:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [VOYAGER] fix build broken by shift to smp_ops
Message-Id: <20070514125946.0f74221c.akpm@linux-foundation.org>
In-Reply-To: <46489818.4000408@goop.org>
References: <1179158912.3703.47.camel@mulgrave.il.steeleye.com>
	<46489818.4000408@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 10:10:48 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> James Bottomley wrote:
> > From: Jeremy Fitzhardinge <jeremy@xensource.com>
> > Subject: [VOYAGER] fix build broken by shift to smp_ops
> >
> > This adds an smp_ops for voyager, and hooks things up appropriately.
> > This is the first baby-step to making subarch runtime switchable.
> >
> > Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> >
> > Rediffed to work in the absence of the smp consolidation patch
> >   
> 
> I think Andrew is carrying that in -mm.  If you're proposing this for
> git, then we may as well pull in that patch too.
> 

Does "that" have name?  I can find no patch in -mm which appears to have
anything to do with SMP consolidation, and this patch applies cleanly to
the current -mm lineup.

