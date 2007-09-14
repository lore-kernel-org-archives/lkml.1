Return-Path: <linux-kernel-owner+w=401wt.eu-S1762150AbXINOWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762150AbXINOWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 10:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbXINOWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 10:22:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbXINOWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 10:22:31 -0400
Date: Fri, 14 Sep 2007 10:20:14 -0400
From: Alan Cox <alan@redhat.com>
To: Christoph Hellwig <hch@infradead.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Neuling <mikey@neuling.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, paulus@samba.org,
       Alan Cox <alan@redhat.com>, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] powerpc: add new required termio functions
Message-ID: <20070914142014.GC20963@devserv.devel.redhat.com>
References: <8018.1189562679@neuling.org> <20070912102032.GB7858@osiris.boeblingen.de.ibm.com> <20070912040109.3f6a9149.akpm@linux-foundation.org> <20070912113409.GA7253@infradead.org> <20070912115257.GC7858@osiris.boeblingen.de.ibm.com> <20070912134910.GA12660@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912134910.GA12660@infradead.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 02:49:10PM +0100, Christoph Hellwig wrote:
> On Wed, Sep 12, 2007 at 01:52:57PM +0200, Heiko Carstens wrote:
> > > I might be missing something, but the the right fix is probably to
> > > apply the arch patches from Alan to powerpc and s390.  We don't want to
> > > be left over without all the nice termios features on these platforms,
> > > do we?
> > 
> > But not in rc6 timeframe, I would guess?
> 
> Ask Alan..

Well i've been chasing people for many months on the 390 side so if they missed
a release tough ...

Alan


-- 
--
		"A wiki is where ideas go to die"
				-- Becky Hogge
