Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbXHHLxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbXHHLxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 07:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbXHHLxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 07:53:30 -0400
Received: from mx12.go2.pl ([193.17.41.142]:46663 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750736AbXHHLx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 07:53:28 -0400
Date: Wed, 8 Aug 2007 13:53:59 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Marcin =?iso-8859-2?Q?=A6lusarz?= <marcin.slusarz@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
Message-ID: <20070808115359.GD2426@ff.dom.local>
References: <20070731132037.GC1046@ff.dom.local> <4bacf17f0708060000n5a00bb77i74adc3b4b28ac42b@mail.gmail.com> <20070806070300.GA4509@elte.hu> <4bacf17f0708070046o14403089v8376a4544f72fec3@mail.gmail.com> <20070807082321.GB2120@ff.dom.local> <4bacf17f0708070237w19d184b3p7f74b53612edb9a6@mail.gmail.com> <20070807095246.GB3223@ff.dom.local> <20070807121339.GA3946@ff.dom.local> <4bacf17f0708080409t116b5c84ye60dff7da51d0fdf@mail.gmail.com> <20070808114243.GC2426@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070808114243.GC2426@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 01:42:43PM +0200, Jarek Poplawski wrote:
...
> So, it looks like x86_64 io_apic's IPI code was unused too long...

To be fair it's x86_64 lapic's IPI code.

Jarek P.
