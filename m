Return-Path: <linux-kernel-owner+w=401wt.eu-S1757771AbZDJIaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbZDJIaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 04:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbZDJI3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 04:29:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44632 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbZDJI3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 04:29:53 -0400
Date: Fri, 10 Apr 2009 10:28:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/30] C/R OpenVZ/Virtuozzo style
Message-ID: <20090410082815.GA17962@elte.hu>
References: <20090410023207.GA27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410023207.GA27788@x200.localdomain>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> This is to show how we see C/R and to provoke discussion on number 
> of important issues (mounts, ...).
> 
> This is small part of long-awaited to be cleanuped code.
> 
> It's able to restore busyloop on i386 and x86_64 and restore i386 
> busyloop on x86_64. It wasn't tested much more than that.
> 
> I'm currently starting formal testsuite, otherwise it's 
> whack-a-mole game and formal TODO list (a huge one).

One simple patch-submission request: if you start sending large 
series of patches then please post it like others do: by using 
git-format-patch or some other tool that preserves the threading of 
the discussion and links all the 1/30..30/30 patches back to the 
0/30 mail.

This submission has created 31 separate threads on lkml, intermixed 
with other threads - making it more difficult to review it as a 
coherent unit.

Thanks,

	Ingo
