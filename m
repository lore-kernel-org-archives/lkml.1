Return-Path: <linux-kernel-owner+w=401wt.eu-S1760993AbZDHIAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760993AbZDHIAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbZDHIA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:00:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58109 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbZDHIAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:00:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
Subject: Re: 2.6.29 on MacBook 2,1 fails to reboot (was Re: 2.6.29-git13: Reported regressions from 2.6.28)
Date: Wed, 8 Apr 2009 10:00:28 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera> <9b1675090904071352x513510ecm8b2574859b088275@mail.gmail.com> <9b1675090904071816k59080f1fn39737767db4dc0c@mail.gmail.com>
In-Reply-To: <9b1675090904071816k59080f1fn39737767db4dc0c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904081000.30313.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 April 2009, Trenton D. Adams wrote:
> On Tue, Apr 7, 2009 at 2:52 PM, Trenton D. Adams
> <trenton.d.adams@gmail.com> wrote:
> > On Tue, Apr 7, 2009 at 1:23 PM, Stefan Richter
> > <stefanr@s5r6.in-berlin.de> wrote:
> >>
> >> But more importantly, is this init scripts related bug really what's
> >> happening at your system?  Or do you actually experience an entirely
> >> different bug?
> >
> > It could be.  I will try it out when I get home from work, and get
> > back to you.  That would be cool if it was a simple init script
> > problem.  Cause then I don't have to do anymore git bisects. ;)
> 
> Yes, the order is what causes this, you can close the bug.

Closed.

Thanks,
Rafael
