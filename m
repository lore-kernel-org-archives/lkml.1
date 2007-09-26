Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbXIZXV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbXIZXV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 19:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbXIZXVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 19:21:52 -0400
Received: from www.osadl.org ([213.239.205.134]:50303 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750777AbXIZXVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 19:21:51 -0400
Subject: Re: [REGRESSION from 2.6.23-rc8] (was: Re: 2.6.23-rc4-mm1 and
	-rc6-mm1: boot failure on HP nx6325, related to clockevents)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200709270130.51870.rjw@sisk.pl>
References: <200709231257.12213.rjw@sisk.pl>
	 <200709262300.28336.rjw@sisk.pl> <1190842476.23376.57.camel@chaos>
	 <200709270130.51870.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 27 Sep 2007 01:21:49 +0200
Message-Id: <1190848909.23376.78.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-27 at 01:30 +0200, Rafael J. Wysocki wrote:
> > > Tested for a couple of times with each kernel, the results seem to be
> > > reproducible 100% of the time.
> > 
> > Thanks for going through this debug marathon.
> 
> No big deal.  I'm glad that you've found what's up.
> 
> Well, we still have the "CPU hotplug during suspend w/ the hrt patch" problem
> to debug ... ;-)

Yeah. Knowing the actual line of code where it breaks might be helpful.

	tglx


