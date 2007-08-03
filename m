Return-Path: <linux-kernel-owner+w=401wt.eu-S1761789AbXHCM0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761789AbXHCM0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 08:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755670AbXHCM0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 08:26:35 -0400
Received: from mx2.go2.pl ([193.17.41.42]:55759 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754925AbXHCM0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 08:26:34 -0400
Date: Fri, 3 Aug 2007 14:26:54 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Marcin =?iso-8859-2?Q?=A6lusarz?= <marcin.slusarz@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Gabriel C <nix.or.die@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch] genirq: fix simple and fasteoi irq handlers
Message-ID: <20070803122654.GA3345@ff.dom.local>
References: <20070726085523.GA3423@ff.dom.local> <20070726091254.GA8063@elte.hu> <4bacf17f0707300029g5116e70bq4808059dc8b069f1@mail.gmail.com> <20070731155843.GA7033@elte.hu> <46B20E47.6020403@googlemail.com> <20070802201126.GA27000@elte.hu> <20070803060733.GA1582@ff.dom.local> <20070803080408.GA12222@elte.hu> <20070803091008.GC1582@ff.dom.local> <4bacf17f0708030457i8d5c32xcd1ec4a0640f3822@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4bacf17f0708030457i8d5c32xcd1ec4a0640f3822@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 01:57:00PM +0200, Marcin ¦lusarz wrote:
...
> I'll test this patch tomorrow (and confirm that the last one from Ingo
> works fine) and report results on monday (sorry, no internet at home
> since I moved out of city :|).

So, you are a lucky guy! I have only no internet at home.
...and time for dreaming about moving out of a city...

Cheers,
Jarek P.
