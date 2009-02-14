Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbZBNWnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbZBNWnV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 17:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbZBNWnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 17:43:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44396 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbZBNWnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:43:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Collins <paul@burly.ondioline.org>
Subject: Re: [Bug #12667] Badness at kernel/time/timekeeping.c:98 in pmud (timekeeping_suspended)
Date: Sat, 14 Feb 2009 23:42:58 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.p4D.L20jJB@chimera> <878wognj00.fsf@burly.wgtn.ondioline.org>
In-Reply-To: <878wognj00.fsf@burly.wgtn.ondioline.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902142342.59186.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 February 2009, Paul Collins wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12667
> > Subject		: Badness at kernel/time/timekeeping.c:98 in pmud (timekeeping_suspended)
> > Submitter	: Paul Collins <paul@burly.ondioline.org>
> > Date		: 2009-01-21 7:15 (19 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1c5745aa380efb6417b5681104b007c8612fb496
> > References	: http://marc.info/?l=linux-kernel&m=123252215315106&w=4
> 
> I've just done ten suspend/resume cycles with 2.6.29-rc4 and this
> message was not logged, so it's either gone away or else become much
> more difficult to reproduce.

Thanks, I've closed the bug.

Sorry for the slow response.

Rafael
