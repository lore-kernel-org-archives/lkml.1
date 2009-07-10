Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbZGJHU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbZGJHU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 03:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbZGJHUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 03:20:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:42989 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbZGJHUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 03:20:20 -0400
Subject: Re: [PATCH 0/44] includecheck: fix multiple includes
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>,
       Sascha Hauer <s.hauer@pengutronix.de>, Ben Dooks <ben-linux@fluff.org>,
       Olaf Weber <olaf@sgi.com>,
       dmitry pervushin <dpervushin@embeddedalley.com>,
       Dave Airlie <airlied@redhat.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       David Howells <dhowells@redhat.com>, benh@kernel.crashing.org,
       paulus@samba.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       jdike@addtoit.com, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       dbrownell@users.sourceforge.net, Greg KH <greg@kroah.com>,
       mchehab@infradead.org, jeremy@xensource.com, felixb@sgi.com,
       lenb@kernel.org, airlied@linux.ie, bcrl@kvack.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1247076059.4382.127.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
	 <1247076059.4382.127.camel@ht.satnam>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 12:47:13 +0530
Message-Id: <1247210233.2471.12.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

On Wed, 2009-07-08 at 23:30 +0530, Jaswinder Singh Rajput wrote:
> Hello all,
> 
> On Wed, 2009-07-08 at 19:58 +0530, Jaswinder Singh Rajput wrote:
> > The following changes since commit faf80d62e44dc627efb741f48db50c1858d1667c:
> >   Linus Torvalds (1):
> >         Merge branch 'x86-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/headers-check-2.6.git master
> > 
> > Jaswinder Singh Rajput (44):
> 
> This is a big patchset, so it will be better that either me or Sam will
> send it to Linus after collecting ACKs.

> I am still waiting ACK/NAK for :
> 

Thanks for all your ACKs and support.

Sorry guys, I give up and do not want to hear more crap from crapy
people just for nothing and withdrawing pull request.

If you want, apply these patches or just trashed it.

Thanks,
--
JSR

