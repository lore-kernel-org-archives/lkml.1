Return-Path: <linux-kernel-owner+w=401wt.eu-S1761551AbXHEJEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761551AbXHEJEv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 05:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752405AbXHEJEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 05:04:44 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48368 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbXHEJEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 05:04:43 -0400
Message-ID: <46B5929B.8070301@garzik.org>
Date: Sun, 05 Aug 2007 05:04:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, J??rn Engel <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
References: <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org> <20070804163733.GA31001@elte.hu> <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org> <46B4C0A8.1000902@garzik.org> <20070804191205.GA24723@lazybastard.org> <20070804192130.GA25346@elte.hu> <20070804211156.5f600d80@the-village.bc.nu> <20070804202830.GA4538@elte.hu> <20070804210351.GA9784@elte.hu> <20070804225121.5c7b66e0@the-village.bc.nu> <20070805073709.GA6325@elte.hu>
In-Reply-To: <20070805073709.GA6325@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Distro makers did not dare to do this sooner because some kernel 
> developers came forward with these mostly bogus arguments ... The impact 
> of atime is far better understood by the kernel community, so it is the 
> responsibility of _us_ to signal such things towards distributors, not 
> the other way around.


Pretty much.

AFAICS there was never a "policy decision" on the part of distro makers 
to begin with.  The kernel had its default -- atime -- and the distros 
ran with that.

	Jeff


