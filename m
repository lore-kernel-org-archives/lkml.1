Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbZHLONK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbZHLONK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 10:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbZHLONJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 10:13:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41304 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752751AbZHLONI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 10:13:08 -0400
Date: Wed, 12 Aug 2009 10:13:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
In-Reply-To: <20090812105106.GA7885@elte.hu>
Message-ID: <Pine.LNX.4.44L0.0908121005370.2955-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009, Ingo Molnar wrote:

> > And here I was thinking kerneldoc doesn't actually work 
> > like that, but perhaps Randy fixed it so the initial 
> > description can line-wrap?

Yes, that's what I thought too.  If kerneldoc has been fixed then the 
description line certainly should get wrapped.

On Wed, 12 Aug 2009, Ingo Molnar wrote:

> Looks good - a small nit: please use proper/consistent line length,
> something like:

> Ah, the main changes i did were to the body, that is what 
> caught my eyes.

Point taken.  Would you like me to reformat the body text and resubmit
the patch?

Alan Stern

