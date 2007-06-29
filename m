Return-Path: <linux-kernel-owner+w=401wt.eu-S933018AbXF2OCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018AbXF2OCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 10:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764286AbXF2OB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 10:01:58 -0400
Received: from matups.math.u-psud.fr ([129.175.50.4]:36565 "EHLO
	matups.math.u-psud.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764210AbXF2OB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 10:01:57 -0400
X-Greylist: delayed 6241 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jun 2007 10:01:57 EDT
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Date: Fri, 29 Jun 2007 16:01:38 +0200
User-Agent: KMail/1.9.7
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com
References: <20070622040014.234651401@goodmis.org> <200706291348.21193.duncan.sands@math.u-psud.fr> <20070629133658.GB19021@ms2.inr.ac.ru>
In-Reply-To: <20070629133658.GB19021@ms2.inr.ac.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706291601.41680.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Old days that was acceptable, you had not gazillion of attempts
> but just a few, but since some time (also old already) it became
> disasterous.

What changed?  And can it be fixed?

Thanks,

Duncan.
