Return-Path: <linux-kernel-owner+w=401wt.eu-S1763642AbXGJRb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763642AbXGJRb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762880AbXGJRbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 13:31:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51320 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762198AbXGJRbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 13:31:05 -0400
Date: Tue, 10 Jul 2007 10:30:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: -mm merge plans for 2.6.23 (pcmcia)
Message-Id: <20070710103039.b6f2b136.akpm@linux-foundation.org>
In-Reply-To: <20070710092958.03b058d8.randy.dunlap@oracle.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<20070710092958.03b058d8.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 09:29:58 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Tue, 10 Jul 2007 01:31:52 -0700 Andrew Morton wrote:
> 
> > 
> > When replying, please rewrite the subject suitably and try to Cc: the
> > appropriate developer(s).
> 
> ...
> 
> > pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
> > use-menuconfig-objects-pcmcia.patch
> > 
> >  Am a bit stuck with the pcmcia patches.  Dominik has disappeared.
> 
> The menuconfig patch looks fine.

Yeah, I'll merge that.

> I looked at the May-2007 discussion of ioctl removal.
> I don't see that much has changed since then, so it's either be
> brave/foolish/whatever and see what happens or just wait.
> I'll gladly send a patch to update the removal date in
> feature-removal-schedule.txt

I have a note here that the ioctl-removal patch needs Dominik
consideration.  I see no rush on it so I'll just sit on it.

