Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbXCEQOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbXCEQOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbXCEQOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:14:22 -0500
Received: from p02c11o142.mxlogic.net ([208.65.145.65]:60265 "EHLO
	p02c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbXCEQOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:14:21 -0500
Date: Mon, 5 Mar 2007 18:14:50 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>, Len Brown <lenb@kernel.org>,
       git@vger.kernel.org
Subject: Re: 2.6.21-rc1: known regressions (part 2)
Message-ID: <20070305161450.GA4972@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <20070227103021.GA2250@kernel.dk> <20070227103407.GA17819@elte.hu> <20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk> <20070301093450.GA8508@elte.hu> <20070301104117.GA22788@elte.hu> <20070301145204.GA25304@elte.hu> <Pine.LNX.4.64.0703011536450.12485@woody.linux-foundation.org> <20070302072100.GB30634@elte.hu> <20070302080441.GA12785@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302080441.GA12785@elte.hu>
User-Agent: Mutt/1.5.11
X-OriginalArrivalTime: 05 Mar 2007 16:16:53.0837 (UTC) FILETIME=[B047FFD0:01C75F41]
X-TM-AS-Product-Ver: SMEX-7.0.0.1526-3.6.1039-15036.000
X-TM-AS-Result: No--4.715600-4.000000-4
X-Spam: [F=0.3758793268; S=0.375(2007010901)]
X-MAIL-FROM: <mst@mellanox.co.il>
X-SOURCE-IP: [194.90.237.34]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Ingo Molnar <mingo@elte.hu>:
>  git-bisect good      0539771d7236b425f285652f6f297cc7939c8f9a
> 
>  81450b73dde07f473a4a7208b209b4c8b7251d90 is first bad commit

I have confirmed these two on my system.

-- 
MST
