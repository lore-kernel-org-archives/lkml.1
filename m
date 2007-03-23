Return-Path: <linux-kernel-owner+w=401wt.eu-S934328AbXCWWPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934328AbXCWWPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 18:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934329AbXCWWPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 18:15:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:54580 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934328AbXCWWPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 18:15:52 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+8/QtvOEK8qZW/znJ1F11Dmd5ldVJC9aXRiEQrUj
	O/rJP//qEUZM8g
Date: Fri, 23 Mar 2007 23:15:50 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Bernhard Walle <bwalle@suse.de>
cc: Andrew Morton <akpm@linuxfoundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/7] Add IRQF_IRQPOLL_IRQ flag to allow irqpoll
In-Reply-To: <20070323164447.659982000@strauss.suse.de>
Message-ID: <Pine.LNX.4.60.0703232312180.5971@poirot.grange>
References: <20070323164447.659982000@strauss.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007, Bernhard Walle wrote:

> irqpoll is broken on some architectures that don't use the IRQ 0 for the timer
> interrupt like IA64. This patch adds a IRQF_IRQPOLL_IRQ flag.

emn, please, cannot we come up with a better name - one that doesn't have 
"IRQ" 3 (!) times in it?...

Thanks
Guennadi
---
Guennadi Liakhovetski
