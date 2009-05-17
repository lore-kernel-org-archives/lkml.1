Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbZEQK2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbZEQK2H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 06:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757739AbZEQK1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 06:27:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46367 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630AbZEQK1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 06:27:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [Bug #13069] regression in 2.6.29-git3 on SH/Dreamcast
Date: Sun, 17 May 2009 12:28:03 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5-rjw; KDE/4.2.2; x86_64; ; )
Cc: Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Manuel Lauss <mano@roarinelk.homelinux.net>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <1240594638.4777.1.camel@localhost.localdomain> <84144f020905170112l789e9ec0p2bf6bb71879579e1@mail.gmail.com>
In-Reply-To: <84144f020905170112l789e9ec0p2bf6bb71879579e1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905171228.04027.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 May 2009, Pekka Enberg wrote:
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

Done.

Thanks,
Rafael
