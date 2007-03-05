Return-Path: <linux-kernel-owner+w=401wt.eu-S933530AbXCEPiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530AbXCEPiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:38:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933525AbXCEPiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:38:06 -0500
Received: from dev.mellanox.co.il ([194.90.237.44]:35991 "EHLO
	dev.mellanox.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933530AbXCEPiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:38:05 -0500
Date: Mon, 5 Mar 2007 17:34:44 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: 2.6.21-rc1: known regressions (part 2)
Message-ID: <20070305153429.GA4783@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070225175559.GC12392@stusta.de> <20070227100202.GV3822@kernel.dk> <20070227102109.GG6745@elf.ucw.cz> <20070227103021.GA2250@kernel.dk> <20070227103407.GA17819@elte.hu> <20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk> <20070301093450.GA8508@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301093450.GA8508@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Ingo Molnar <mingo@elte.hu>:
> Subject: Re: 2.6.21-rc1: known regressions (part 2)
> 
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38 works for me, [...]
> 
> update: f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38 works for me too, and 
> 01363220f5d23ef68276db8974e46a502e43d01d is broken. I too will attempt 
> to bisect this.

f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38 works for me, too.

-- 
MST
