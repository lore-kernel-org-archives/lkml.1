Return-Path: <linux-kernel-owner+w=401wt.eu-S1761619AbXGKKhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761619AbXGKKhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 06:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759647AbXGKKgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 06:36:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:41926 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759108AbXGKKgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 06:36:53 -0400
Cc: schwidefsky@de.ibm.com, aarora@in.ibm.com, ak@suse.de,
       linux-kernel@vger.kernel.org, tytso@mit.edu, heiko.carstens@de.ibm.com,
       akpm@linux-foundation.org
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 11 Jul 2007 12:36:52 +0200
From: "Michael Kerrisk" <michael.kerrisk@gmx.net>
In-Reply-To: <4694A58A.8020401@yahoo.com.au>
Message-ID: <20070711103652.58230@gmx.net>
MIME-Version: 1.0
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
 <20070710090737.GA16519@osiris.boeblingen.de.ibm.com>
 <20070710022213.81e7b432.akpm@linux-foundation.org>
 <20070710154503.GC27033@thunk.org> <20070710180531.GB8908@osiris.ibm.com>
 <20070710114119.d8e874a1.akpm@linux-foundation.org>
 <20070711093626.GB19061@infradead.org> <4694A58A.8020401@yahoo.com.au>
Subject: Re: testcases, was Re: -mm merge plans for 2.6.23 -- sys_fallocate
To: Nick Piggin <nickpiggin@yahoo.com.au>, hch@infradead.org
X-Authenticated: #2864774
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18irwk2c3wiC0i6cIzNeGuPTJCRfIxTo1Wachaoo1
 VopS0j9By9RKxmiWWLQKU2kl73kOzM76Durg== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: 84qhcvRcRkkNffLMWGRq2SBudWkvKFMC
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Christoph Hellwig wrote:
> > On Tue, Jul 10, 2007 at 11:41:19AM -0700, Andrew Morton wrote:
> > 
> >>I'd support an ununofficial rule that submitters of new syscalls also
> >> raise a patch against LTP, come to that...
> > 
> > 
> > s/ununofficial//, please.  And extend this to every new kernel interface
> > that's not bound to a specific piece of hardware.
> 
> Agree, and cc manpages maintainer too? (preferably write most
> of the manpage body as well, IMO).

Yes, please.  Docs written by, or with input from, the implementer
provide one of the few ways for everyone else to spot differences
between implementation and intention.
-- 
Ist Ihr Browser Vista-kompatibel? Jetzt die neuesten 
Browser-Versionen downloaden: http://www.gmx.net/de/go/browser
