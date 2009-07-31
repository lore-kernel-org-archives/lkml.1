Return-Path: <linux-kernel-owner+w=401wt.eu-S1752371AbZGaKqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbZGaKqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 06:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbZGaKqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 06:46:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:45114 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZGaKqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 06:46:10 -0400
Subject: Re: [GIT pull] timers fixes for 2.6.31
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>
In-Reply-To: <alpine.LFD.2.01.0907301648540.3161@localhost.localdomain>
References: <alpine.LFD.2.00.0907302158180.2936@localhost.localdomain>
	 <alpine.LFD.2.01.0907301648540.3161@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 31 Jul 2009 12:45:59 +0200
Message-Id: <1249037159.7924.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 16:49 -0700, Linus Torvalds wrote:
> 
> On Thu, 30 Jul 2009, Thomas Gleixner wrote:
> > 
> > Please pull the latest timers-fixes-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus
> > 
> > Thanks,
> > 
> > 	tglx
> > 
> > ------------------>
> > Magnus Damm (1):
> >       clocksource: save mult_orig in clocksource_disable()
> > 
> >  include/linux/clocksource.h |   12 +++++++++++-
> >  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> Hmm. You seem to have forgotten to push this out. I realize you're off to 
> vacation, do you have time to check that?

I can't find this merge in Linus' tree as of this writing, so I'm
assuming tglx vanished. Peter can you put that commit in the mentioned
tip branch?

Alternatively, I can stick it in a git tree for Linus.
