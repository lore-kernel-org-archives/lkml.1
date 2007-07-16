Return-Path: <linux-kernel-owner+w=401wt.eu-S1760836AbXGPXdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760836AbXGPXdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbXGPXdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:33:24 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:53012 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbXGPXdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:33:23 -0400
Message-ID: <469C0008.1090001@gmail.com>
Date: Tue, 17 Jul 2007 01:32:24 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Ray Lee <ray-lk@madrabbit.org>, Bodo Eggert <7eggert@gmx.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it> <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com> <Pine.LNX.4.58.0707161523500.25779@be1.lrz> <469BF104.1040703@gmail.com> <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com> <469BF768.6040200@gmail.com> <20070716230719.GC11115@waste.org> <469BFB73.3070105@gmail.com> <20070716232755.GD11115@waste.org>
In-Reply-To: <20070716232755.GD11115@waste.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2007 01:27 AM, Matt Mackall wrote:

> Larger soft pages waste tremendous amounts of memory (mostly in page
> cache) for minimal benefit on, say, the typical desktop. While there
> are workloads where it's a win, it's probably on a small percentage of
> machines.
> 
> So it's absolutely no help in fixing our order-1 allocation problem 
> because we don't want to force large pages on people.

Okay. I would've expected that 4K was fairly tiny for today's loads but as 
usual I'm relatively data challenged so I guess I'll take your word for it. 
Bummer.

Rene.

