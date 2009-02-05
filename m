Return-Path: <linux-kernel-owner+w=401wt.eu-S1760433AbZBEA4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760433AbZBEA4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbZBEA4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:56:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49023 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbZBEA4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:56:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #12417] glx performance drop with: "x86: PAT: implement track/untrack of pfnmap regions for x86 - v3"
Date: Thu, 5 Feb 2009 01:55:42 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Alexey Fisher <bug-track@fisher-privat.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <4989BC16.4080602@fisher-privat.net> <20090204164257.GD25996@elte.hu>
In-Reply-To: <20090204164257.GD25996@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902050155.43607.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, Ingo Molnar wrote:
> 
> * Alexey Fisher <bug-track@fisher-privat.net> wrote:
> 
> > Ingo Molnar schrieb:
> >> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >>
> >>> This message has been generated automatically as a part of a report
> >>> of recent regressions.
> >>>
> >>> The following bug entry is on the current list of known regressions
> >>> from 2.6.28.  Please verify if it still should be listed and let me know
> >>> (either way).
> >>>
> >>>
> >>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12417
> >>> Subject		: glx performance drop with: "x86: PAT: implement track/untrack of pfnmap regions for x86 - v3"
> >>> Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
> >>> Date		: 2009-01-06 18:46 (30 days old)
> >>> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5899329b19100c0b82dc78e9b21ed8b920c9ffb3
> >>> References	: http://marc.info/?l=linux-kernel&m=123126782822696&w=4
> >>> Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
> >>> 		  Ingo Molnar <mingo@elte.hu>
> >>>
> >>
> >> this should be fixed in latest -git. Alexey, can you confirm?
> >>
> >> 	Ingo
> >
> > I confirm it. It working  great with latest git 2.6.29-rc3-00495-gdcf6a79.
> 
> Thanks for the testing!

Closed.

Thanks,
Rafael
