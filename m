Return-Path: <linux-kernel-owner+w=401wt.eu-S1760665AbZDBVew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665AbZDBVew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 17:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbZDBVen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 17:34:43 -0400
Received: from www.tglx.de ([62.245.132.106]:50927 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbZDBVem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 17:34:42 -0400
Date: Thu, 2 Apr 2009 23:33:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] kbuild: work around distcc/icecc madness
In-Reply-To: <20090321141800.GB22029@elte.hu>
Message-ID: <alpine.LFD.2.00.0904022327540.12916@localhost.localdomain>
References: <alpine.LFD.2.00.0903192121300.29264@localhost.localdomain> <20090320092234.GA3792@elte.hu> <alpine.LFD.2.00.0903201127360.29264@localhost.localdomain> <20090320185917.GB6224@elte.hu> <alpine.LFD.2.00.0903202010250.29264@localhost.localdomain>
 <20090320193334.GA19501@elte.hu> <alpine.LFD.2.00.0903202123310.29264@localhost.localdomain> <20090321141800.GB22029@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Mar 2009, Ingo Molnar wrote:
> 
> I'll try to reproduce it once more and see what's going on.

It'd be nice if you could spare some time and try to figure out what's
going on. Everytime I forget to apply that patch to one of my trees I
run into random full kernel rebuilds, which becomes pretty annoying.
Especially when I try to reproduce some user problem with the users's
config which is usually based on some distro config + some random
changes (i.e. builds every random driver and some more).

Thanks,

	tglx
