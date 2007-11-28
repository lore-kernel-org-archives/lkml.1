Return-Path: <linux-kernel-owner+w=401wt.eu-S1759654AbXK1LY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759654AbXK1LY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 06:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759275AbXK1LYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 06:24:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48768 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756354AbXK1LYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 06:24:51 -0500
Date: Wed, 28 Nov 2007 12:24:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew <jackdachef@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CFS scheduler, -v24, for v2.6.24-rc3-git3 / current git state
Message-ID: <20071128112438.GA321@elte.hu>
References: <e85b9d30711280217j104f3117oac4a0fe5bedb5cf1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e85b9d30711280217j104f3117oac4a0fe5bedb5cf1@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew <jackdachef@gmail.com> wrote:

> Hi Ingo & the other contributors of CFS,
> 
> I just wanted to say thank you for your excellent job on this scheduler :)
> 
> I didn't want to tell anything about v24 too fast since testing takes
> its time ;)
> 
> so here my experience so far:
> 
> - no sound stuttering anymore during internet sound streaming even
> during heavy compiling (maybe there's still stuttering but I can't
> hear it *g*)
> - desktop feels really responsive

cool. Which scheduler are you comparing this to - v2.6.23-ish? Or 
CFS-v22?

> - even firefox with around 30 tabs and fully used memory (4 GB) &
> fully used swap (2.5 GB) stil feels quite responsive & great to work
> with (probably it's also thanks to ck-patchset I'm using besides cfs
> -> zen-sources)

which patches does "ck-patchset" carry at the moment? One would be 
swap-prefetch i guess, right?

> - haven't tested 3d FPS so can't tell
> 
> keep up the great work !

thanks :)

	Ingo
