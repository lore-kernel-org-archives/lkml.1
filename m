Return-Path: <linux-kernel-owner+w=401wt.eu-S937553AbXHPAyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937553AbXHPAyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 20:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933712AbXHPAxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 20:53:41 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1683 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758509AbXHPAxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 20:53:39 -0400
Date: Thu, 16 Aug 2007 08:53:16 +0800
From: Herbert Xu <herbert.xu@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>, Satyam Sharma <satyam@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Christoph Lameter <clameter@sgi.com>, Chris Snook <csnook@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com, segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Message-ID: <20070816005316.GA29802@gondor.apana.org.au>
References: <alpine.LFD.0.999.0708151906330.16414@enigma.security.iitk.ac.in> <20070815142516.GB9645@linux.vnet.ibm.com> <4413.1187201997@redhat.com> <20070815184520.GG9645@linux.vnet.ibm.com> <20070815234146.GB28775@gondor.apana.org.au> <20070815235335.GU9645@linux.vnet.ibm.com> <20070816001248.GA29214@gondor.apana.org.au> <20070816002310.GW9645@linux.vnet.ibm.com> <20070816003023.GA29447@gondor.apana.org.au> <20070816004950.GZ9645@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816004950.GZ9645@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 05:49:50PM -0700, Paul E. McKenney wrote:
> On Thu, Aug 16, 2007 at 08:30:23AM +0800, Herbert Xu wrote:
>
> > Thanks.  But I don't need a summary of the thread, I'm asking
> > for an extant code snippet in our kernel that benefits from
> > the volatile change and is not part of a busy-wait.
> 
> Sorry, can't help you there.  I really do believe that the information
> you need (as opposed to the specific item you are asking for) really
> has been put forth in this thread.

That only leads me to believe that such a code snippet simply
does not exist.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
