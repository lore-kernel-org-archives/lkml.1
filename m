Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbZB1HVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbZB1HVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 02:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbZB1HVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 02:21:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47726 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbZB1HVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 02:21:08 -0500
Date: Sat, 28 Feb 2009 08:20:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: core dom0 support
Message-ID: <20090228072055.GC9351@elte.hu>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org> <49A8DF28.4050301@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A8DF28.4050301@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> [...] At the moment its all running on massive out-of-tree 
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> patches, which doesn't make anyone happy.  It's best that it 
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> be in the mainline kernel.  You know, like we argue for 
> everything else.
>
>> In three years time, will we regret having merged this?
>
> Its a pretty minor amount of extra stuff on top of what's been 
> added over the last 3 years, so I don't think it's going to 
> tip the scales on its own.  I wouldn't be comfortable in 
> trying to merge something that's very intrusive.

Hm, how can the same code that you call "massive out-of-tree 
patches which doesn't make anyone happy" in an out of tree 
context suddenly become non-intrusive "minor amount of extra 
stuff" in an upstream context?

I wish the upstream kernel was able to do such magic, but i'm 
afraid it is not.

	Ingo
