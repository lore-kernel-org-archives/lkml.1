Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304AbZBIHyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbZBIHyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 02:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZBIHxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 02:53:53 -0500
Received: from jenny.ondioline.org ([66.220.1.122]:59765 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbZBIHxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 02:53:53 -0500
From: Paul Collins <paul@burly.ondioline.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [Bug #12667] Badness at kernel/time/timekeeping.c:98 in pmud (timekeeping_suspended)
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
	<sWhNs83kKPE.A.p4D.L20jJB@chimera>
Date: Mon, 09 Feb 2009 20:53:51 +1300
In-Reply-To: <sWhNs83kKPE.A.p4D.L20jJB@chimera> (Rafael J. Wysocki's message
	of "Sun, 8 Feb 2009 20:21:49 +0100 (CET)")
Message-ID: <878wognj00.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12667
> Subject		: Badness at kernel/time/timekeeping.c:98 in pmud (timekeeping_suspended)
> Submitter	: Paul Collins <paul@burly.ondioline.org>
> Date		: 2009-01-21 7:15 (19 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1c5745aa380efb6417b5681104b007c8612fb496
> References	: http://marc.info/?l=linux-kernel&m=123252215315106&w=4

I've just done ten suspend/resume cycles with 2.6.29-rc4 and this
message was not logged, so it's either gone away or else become much
more difficult to reproduce.

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
