Return-Path: <linux-kernel-owner+w=401wt.eu-S1161182AbXEBGHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161182AbXEBGHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161263AbXEBGHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:07:15 -0400
Received: from www.osadl.org ([213.239.205.134]:54443 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161182AbXEBGHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:07:14 -0400
Subject: Re: [patch 0/3] Clocksource / clockevent updates
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20070501173356.15e9d482.akpm@linux-foundation.org>
References: <20070430102837.748238000@linutronix.de>
	 <20070501173356.15e9d482.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 02 May 2007 08:09:29 +0200
Message-Id: <1178086170.5791.338.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 17:33 -0700, Andrew Morton wrote:
> On Mon, 30 Apr 2007 10:43:31 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > Andrew,
> > 
> > please pick up the following updates to clocksource / clockevents:
> > 
> > - Fixups to the resume logic
> > - Keep TSC stable, when lapic_timer_c2_ok is set
> > 
> 
> Should we be targetting these at 2.6.20.x?

2.6.21.x ?

Hmm. They should get some testing first, but otherwise yes.

	tglx


