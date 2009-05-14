Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbZENNqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbZENNqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbZENNp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:45:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42422 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbZENNpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:45:55 -0400
Date: Thu, 14 May 2009 15:39:08 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] itimers: periodic timers fixes
Message-ID: <20090514153908.0e689f70@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <alpine.LFD.2.00.0905122308350.3561@localhost.localdomain>
References: <20090402141135.655d1b2b@dhcp-lab-109.englab.brq.redhat.com>
	<20090402165753.GA12793@elte.hu>
	<20090415142232.46a97f70@dhcp-lab-109.englab.brq.redhat.com>
	<20090415135902.GC12760@elte.hu>
	<alpine.LFD.2.00.0905122308350.3561@localhost.localdomain>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009 23:11:57 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Wed, 15 Apr 2009, Ingo Molnar wrote:
> > > Could the patches be merged and possible other work done in later 
> > > time? Or perhaps I should rework on them?
> > 
> > It's up to Thomas - but they certainly looked good to me.
> 
> Huch, did I inherit the cputimers horror as a gratification for
> touching kernel/*timer* at some point ?
> 
> Seriously, give me a day or two to have a close look. I'm fighting
> with a set of other timer related patches which I have delayed long
> enough already.

Thomas is your timers work accessible somewhere? I'm planing to do more
changes in posix timers area and don't want to duplicate your work.

Cheers
Stanislaw
