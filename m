Return-Path: <linux-kernel-owner+w=401wt.eu-S1757719AbXLUJ5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719AbXLUJ5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 04:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbXLUJ5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 04:57:30 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3312 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753102AbXLUJ53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 04:57:29 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: alan@lxorguk.ukuu.org.uk (Alan Cox)
Subject: Re: Trailing periods in kernel messages
Cc: joe@perches.com, davem@davemloft.net, apw@shadowen.org,
       lizf@cn.fujitsu.com, akpm@linux-foundation.org, elendil@planet.nl,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, trivial@kernel.org,
       rdunlap@xenotime.net, jschopp@austin.ibm.com
Organization: Core
In-Reply-To: <20071220220853.4f7c639c@the-village.bc.nu>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1J5ecS-0008UX-00@gondolin.me.apana.org.au>
Date: Fri, 21 Dec 2007 17:56:40 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> I do not believe "opinions" are relevant here. Relevant would be cites
> from respected style guides (Fowlers, Oxford Guide To Style et al.) to
> show they do not need a full stop. 
> 
> I've not found one, but I am open to references.

Well from where I come from, full stops are only used for complete
sentences.  For example,

http://www.ballarat.edu.au/aasp/student/learning_support/generalguide/ch01s05s02.shtml

As to what is a complete sentence, that is debatable.  However,
typically it would include a subject and a predicate.  By this
rule the following line is not a complete sentence:

	[XFS] Initialise current offset in xfs_file_readdir correctly

The reason is that it lacks a subject.

Of course I would completely agree that some kernel messages
are complete sentences and should have a full stop.  However,
it is not clear to me that this is the case for all or even
most kernel printk messages.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
