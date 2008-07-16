Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbYGPEdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbYGPEdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 00:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYGPEdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 00:33:37 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:59954 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751061AbYGPEdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 00:33:36 -0400
Date: Wed, 16 Jul 2008 12:33:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, davem@davemloft.net, mingo@elte.hu,
       nhorman@tuxdriver.com, simon@fire.lp0.eu, linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 000000000000000e (reset_prng_context)
Message-ID: <20080716043312.GA12765@gondor.apana.org.au>
References: <487BE071.80101@simon.arlott.org.uk> <20080715020428.GA27463@hmsendeavour.rdu.redhat.com> <20080715113304.GA30565@elte.hu> <20080715.134407.150543177.davem@davemloft.net> <20080715214929.GA18268@martell.zuzino.mipt.ru> <20080715151110.d7a17c89.akpm@linux-foundation.org> <20080716040701.GA12570@gondor.apana.org.au> <20080715212549.1c41c1d0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715212549.1c41c1d0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 09:25:49PM -0700, Andrew Morton wrote:
> On Wed, 16 Jul 2008 12:07:01 +0800 Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
> > On Tue, Jul 15, 2008 at 03:11:10PM -0700, Andrew Morton wrote:
> > >
> > > Except that such a high density of coding-style errors is an indication
> > > that the code was not closely and critically reviewed by an experienced
> > > kernel developer.
> > > 
> > > > Every damn single warning in this case is about whitespace or 80 column limit.
> > > > 
> > > > Every damn single one!
> > 
> > Indeed, I apologise for reviewing the code on a monitor that is wider
> > than yours.  If only we could make sure that all Linux developers
> > used smaller monitors then the code quality would surely improve!
> > 
> 
> Remaining within 80 cols is a big deal indeed for those who choose to
> use, or who are forced to use 80-col displays.  Try resizing to 70 cols
> for a while, see how you get on.

Sure, I totally understand the 80-column requirement and support
it too.

However, I fail to see how one could draw the conclusion that a
piece of code that breaks the 80-column rule has not been closely
or critically reviewed.

Excuse me for not focusing on white-space or code-width issues
when reviewing code.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
