Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbYAHIDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbYAHIDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 03:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYAHIDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 03:03:09 -0500
Received: from www.tglx.de ([62.245.132.106]:45376 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbYAHIDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 03:03:08 -0500
Date: Tue, 8 Jan 2008 09:02:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Parag Warudkar <parag.warudkar@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.24-rc6-git12: Reported regressions from 2.6.23
In-Reply-To: <82e4877d0801071649vd0af3a0h7cb7cbd0b58353ed@mail.gmail.com>
Message-ID: <alpine.LFD.0.99999.0801080900160.31637@localhost.localdomain>
References: <200801052042.56042.rjw@sisk.pl> <200801062011.31491.rjw@sisk.pl>  <82e4877d0801071521s607491f1ue25c4b97de47db71@mail.gmail.com>  <200801080054.57916.rjw@sisk.pl> <82e4877d0801071649vd0af3a0h7cb7cbd0b58353ed@mail.gmail.com>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008, Parag Warudkar wrote:

> On Jan 7, 2008 6:54 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > Well, now you're saying 2.6.23.12 is also affected, so this doesn't seem to
> > be a recent regression in fact?
> >
> 
> I have run 2.6.23 series before but my usage pattern seems to have not
> triggered the bug before.
> But yes, this is a 6 month old regression based on today's findings.
> (2.6.22 which doesn't have this issue was released on July 8).

Hmm. Can you try plain 2.6.23 ? If it does not show the problem we
know that it is caused by one of the patches in the stable series.

Thanks,

	tglx
