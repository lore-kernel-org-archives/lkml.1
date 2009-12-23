Return-Path: <linux-kernel-owner+w=401wt.eu-S1752944AbZLWI3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbZLWI3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 03:29:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbZLWI3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 03:29:09 -0500
Received: from a.mx.secunet.com ([213.68.205.161]:47779 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbZLWI3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 03:29:08 -0500
X-Greylist: delayed 1615 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Dec 2009 03:29:08 EST
Date: Wed, 23 Dec 2009 09:00:00 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       mingo@elte.hu, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net, "David S. Miller" <davem@davemloft.net>
Subject: Re: workqueue thing
Message-ID: <20091223080000.GA32467@secunet.com>
References: <4B2F768C.1040704@kernel.org> <4B2F7DD2.2080902@linux.intel.com> <4B2F83F6.2040705@kernel.org> <4B2F9212.3000407@linux.intel.com> <4B300C01.8080904@kernel.org> <1261480220.4937.24.camel@laptop> <alpine.LFD.2.00.0912220917270.31313@localhost.localdomain> <1261504042.4937.59.camel@laptop> <4B31907C.7070408@kernel.org> <20091223065240.GA27225@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091223065240.GA27225@gondor.apana.org.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 23 Dec 2009 08:02:12.0368 (UTC) FILETIME=[3BBF4100:01CA83A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 02:52:40PM +0800, Herbert Xu wrote:
> 
> However, Steffen Klassert has proposed a parallelisation mechanism
> whereby extremely CPU-intensive operations such as encryption may
> be split across CPUs.  Steffen, could you repost your padata patches
> here?
> 

Yes, I'll send the same version I sent to linux-crypto last week in
reply to this mail.

Steffen
