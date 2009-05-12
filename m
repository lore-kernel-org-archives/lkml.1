Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbZELVMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbZELVMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 17:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbZELVM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 17:12:29 -0400
Received: from www.tglx.de ([62.245.132.106]:50515 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbZELVM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 17:12:28 -0400
Date: Tue, 12 May 2009 23:11:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Stanislaw Gruszka <sgruszka@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] itimers: periodic timers fixes
In-Reply-To: <20090415135902.GC12760@elte.hu>
Message-ID: <alpine.LFD.2.00.0905122308350.3561@localhost.localdomain>
References: <20090402141135.655d1b2b@dhcp-lab-109.englab.brq.redhat.com> <20090402165753.GA12793@elte.hu> <20090415142232.46a97f70@dhcp-lab-109.englab.brq.redhat.com> <20090415135902.GC12760@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009, Ingo Molnar wrote:
> > Could the patches be merged and possible other work done in later 
> > time? Or perhaps I should rework on them?
> 
> It's up to Thomas - but they certainly looked good to me.

Huch, did I inherit the cputimers horror as a gratification for
touching kernel/*timer* at some point ?

Seriously, give me a day or two to have a close look. I'm fighting
with a set of other timer related patches which I have delayed long
enough already.

Thanks,

	tglx
