Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277AbXLUKKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbXLUKKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 05:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750718AbXLUKKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 05:10:40 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:59681 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbXLUKKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 05:10:40 -0500
Date: Fri, 21 Dec 2007 11:10:38 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, joe@perches.com, davem@davemloft.net,
       apw@shadowen.org, lizf@cn.fujitsu.com, akpm@linux-foundation.org,
       elendil@planet.nl, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       trivial@kernel.org, rdunlap@xenotime.net, jschopp@austin.ibm.com
Subject: Re: Trailing periods in kernel messages
In-Reply-To: <E1J5ecS-0008UX-00@gondolin.me.apana.org.au>
Message-ID: <Pine.LNX.4.64.0712211104080.21721@fbirervta.pbzchgretzou.qr>
References: <E1J5ecS-0008UX-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 21 2007 17:56, Herbert Xu wrote:
>> 
>> I do not believe "opinions" are relevant here. Relevant would be cites
>> from respected style guides (Fowlers, Oxford Guide To Style et al.) to
>> show they do not need a full stop. 
>> 
>> I've not found one, but I am open to references.
>
>Well from where I come from, full stops are only used for complete
>sentences.
>[...]
>As to what is a complete sentence, that is debatable.  However,
>typically it would include a subject and a predicate.  By this
>rule the following line is not a complete sentence:
>
>	[XFS] Initialise current offset in xfs_file_readdir correctly
>
>The reason is that it lacks a subject.

"current offset" is your subject.

But I would tend to agree to "(most) kernel messages are not sentences."

Actually, I see it a bit different: (most) kernel messages are more like an
itemized list of what has been done/is going to be done. A *list*!

 * water
 * flour
 * salt
 * yeast or baking powder
 * dough (obviously)

(I'm a programmer, not a cook.) Would you really add a fullstop?

>Of course I would completely agree that some kernel messages
>are complete sentences and should have a full stop.

+1. Those kernel messages which clearly have two or more sentences
obviously have sentences. ("If a device doesn't work, try "pci=routeirq".)

Can we get back to programming?
