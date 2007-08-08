Return-Path: <linux-kernel-owner+w=401wt.eu-S936197AbXHHTk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936197AbXHHTk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 15:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763772AbXHHTkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 15:40:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35366 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760112AbXHHTkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 15:40:15 -0400
Message-ID: <46BA1C08.4050904@garzik.org>
Date: Wed, 08 Aug 2007 15:39:52 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       J??rn Engel <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
References: <20070804191205.GA24723@lazybastard.org> <20070804192130.GA25346@elte.hu> <20070804211156.5f600d80@the-village.bc.nu> <20070804202830.GA4538@elte.hu> <20070804210351.GA9784@elte.hu> <20070804225121.5c7b66e0@the-village.bc.nu> <20070805073709.GA6325@elte.hu> <20070805134328.1a4474dd@the-village.bc.nu> <20070805125433.GA22060@elte.hu> <20070805143708.279f51f8@the-village.bc.nu> <20070805180826.GD3244@elte.hu> <46BA09CC.7070007@tmr.com>
In-Reply-To: <46BA09CC.7070007@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> Being standards compliant is not an argument it's a design goal, a 
> requirement. Standards compliance is like pregant, you are or you're 

Linux history says different.  There was always the "final 1%" of 
compliance that required silliness we really did not want to bother with.

	Jeff


