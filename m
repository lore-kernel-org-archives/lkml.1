Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab0AONjh (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 08:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810Ab0AONjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 08:39:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33764 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751069Ab0AONjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 08:39:36 -0500
Date: Fri, 15 Jan 2010 13:39:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia@diku.dk>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, David Miller <davem@davemloft.net>,
        stefanr@s5r6.in-berlin.de, adi@hexapodia.org, nm127@freemail.hu,
        david.vrabel@csr.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Palix <npalix@diku.dk>
Subject: Re: Changelog quality
Message-ID: <20100115133933.GB21188@rakim.wolfsonmicro.main>
References: <4B502C6B.7000802@s5r6.in-berlin.de>
 <20100115.005445.263291449.davem@davemloft.net>
 <tkrat.e88dd4dbf17f9bde@s5r6.in-berlin.de>
 <20100115.012233.202457727.davem@davemloft.net>
 <Pine.LNX.4.64.1001151039080.23543@ask.diku.dk>
 <84144f021001150149u3b784d26g1822be6c5c3ecbf@mail.gmail.com>
 <Pine.LNX.4.64.1001151101320.23543@ask.diku.dk>
 <20100115110845.GB28625@sirena.org.uk>
 <Pine.LNX.4.64.1001151303580.23543@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1001151303580.23543@ask.diku.dk>
X-Cookie: Do unto others before they undo you.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 01:06:04PM +0100, Julia Lawall wrote:
> On Fri, 15 Jan 2010, Mark Brown wrote:

> > This would also mean that other people could run and re-run the scripts
> > during development much more easily which would help improve the
> > coverage of new code.

> On the other hand, one has to take into account the fact that at least in 
> my case, the patches that are submitted are the ones that I have carefully 
> checked for correctness.  Having a make target in the kernel might give 
> some suggestion of quality that is perhaps not appropriate?

This is a general problem with any tool that generates warnings - we
already have to educate people about how to use the GCC and sparse
warnings appropriately, I can't see that these warnings would be any
different.
