Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091AbZDOOGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbZDOOGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 10:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbZDOOG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 10:06:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38074 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156AbZDOOG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 10:06:29 -0400
Date: Wed, 15 Apr 2009 16:02:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] itimers: periodic timers fixes
Message-ID: <20090415140230.GA12518@redhat.com>
References: <20090402141135.655d1b2b@dhcp-lab-109.englab.brq.redhat.com> <20090402165753.GA12793@elte.hu> <20090415142232.46a97f70@dhcp-lab-109.englab.brq.redhat.com> <20090415135902.GC12760@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415135902.GC12760@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15, Ingo Molnar wrote:
>
> * Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >
> > Could the patches be merged and possible other work done in later
> > time? Or perhaps I should rework on them?
>
> It's up to Thomas - but they certainly looked good to me.

Just in case, I think these patches are good too.

And personally I really like the fact Stanislaw simplified the related
code first.

Oleg.

