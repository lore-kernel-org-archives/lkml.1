Return-Path: <linux-kernel-owner+w=401wt.eu-S1752079AbXE2WmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbXE2WmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbXE2WmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:42:16 -0400
Received: from www.osadl.org ([213.239.205.134]:38961 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751482AbXE2WmP (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:42:15 -0400
Subject: Re: [BUG] Something goes wrong with timer statistics.
From: Thomas Gleixner <tglx@linutronix.de>
To: David Miller <davem@davemloft.net>
Cc: iank@bredband.net, Linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20070529.153723.108751260.davem@davemloft.net>
References: <1180474738.22497.25.camel@pi.pomac.com>
	 <20070529.153723.108751260.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 30 May 2007 00:42:12 +0200
Message-Id: <1180478532.20546.41.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-29 at 15:37 -0700, David Miller wrote:
> From: Ian Kumlien <iank@bredband.net>
> Date: Tue, 29 May 2007 23:38:48 +0200
> 
> > As the daystar sets, i try to play some with my new would be
> > firewall/server, but since this will be running for quite some time i
> > have been experimenting with powertop to find out what i can do to limit
> > it's power usage.
> > 
> > But, if i run powertop for too long or a few times to many... this
> > happens:
> > http://pomac.netswarm.net/pics/kernel_panic.jpg
> > 
> > If i don't run powertop, it is rock solid... Compiling for hours,
> > running memtest for hours etc etc... 
> 
> I see this same exact problem on sparc64.

100% reproducible ?

	tglx



