Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbZEQKjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbZEQKjJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 06:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZEQKiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 06:38:54 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:45355 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753253AbZEQKix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 06:38:53 -0400
X-Trace: 200042701/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.64.35/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.41.64.35
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-SMTP-AUTH: 
X-MUA: Evolution 2.26.1 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8IACOGD0pQKUAj/2dsb2JhbACBToEwzFGCQoE/BQ
X-IronPort-AV: E=Sophos;i="4.41,207,1241391600"; 
   d="scan'208";a="200042701"
Subject: Re: [Bug #13069] regression in 2.6.29-git3 on SH/Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Manuel Lauss <mano@roarinelk.homelinux.net>
In-Reply-To: <84144f020905170112l789e9ec0p2bf6bb71879579e1@mail.gmail.com>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
	 <nY3-4PrO6XH.A.QZB.ow85JB@chimera>
	 <1240594638.4777.1.camel@localhost.localdomain>
	 <84144f020905170112l789e9ec0p2bf6bb71879579e1@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 17 May 2009 11:38:35 +0100
Message-Id: <1242556715.4568.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-17 at 11:12 +0300, Pekka Enberg wrote:
> On Thu, 2009-04-16 at 23:45 +0200, Rafael J. Wysocki wrote:
> >> This message has been generated automatically as a part of a report
> >> of recent regressions.
> >>
> >> The following bug entry is on the current list of known regressions
> >> from 2.6.29.  Please verify if it still should be listed and let me know
> >> (either way).
> >>
> >>
> >> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=13069
> >> Subject               : regression in 2.6.29-git3 on SH/Dreamcast
> >> Submitter     : Adrian McMenamin <adrian@newgolddream.dyndns.info>
> >> Date          : 2009-03-29 19:04 (19 days old)
> >> References    : http://marc.info/?l=linux-kernel&m=123835353115372&w=4
> 
> On Fri, Apr 24, 2009 at 8:37 PM, Adrian McMenamin
> <adrian@newgolddream.info> wrote:
> > At this point it *looks* as though it was simply a question of
> > insufficient memory to boot, but I think it needs further testing.
> > Nobody else seems to have picked it up though.
> 
> Yeah, it looks like there's not enough memory to boot. It could well
> be that the kernel memory footprint got bigger but I don't think the
> bisected commit is at fault here. Perhaps we should just close the
> bug?

I think that is probably the best course of action for now, yes.

