Return-Path: <linux-kernel-owner+w=401wt.eu-S1759803AbXLULzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759803AbXLULzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 06:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759392AbXLULzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 06:55:19 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:48914 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbXLULzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 06:55:18 -0500
Date: Fri, 21 Dec 2007 12:55:16 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, joe@perches.com, davem@davemloft.net,
       apw@shadowen.org, lizf@cn.fujitsu.com, akpm@linux-foundation.org,
       elendil@planet.nl, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       trivial@kernel.org, rdunlap@xenotime.net, jschopp@austin.ibm.com
Subject: Re: Trailing periods in kernel messages
In-Reply-To: <20071221114103.GA801@gondor.apana.org.au>
Message-ID: <Pine.LNX.4.64.0712211254160.21721@fbirervta.pbzchgretzou.qr>
References: <E1J5ecS-0008UX-00@gondolin.me.apana.org.au>
 <Pine.LNX.4.64.0712211104080.21721@fbirervta.pbzchgretzou.qr>
 <20071221114103.GA801@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 21 2007 19:41, Herbert Xu wrote:
>On Fri, Dec 21, 2007 at 11:10:38AM +0100, Jan Engelhardt wrote:
>>
>> >	[XFS] Initialise current offset in xfs_file_readdir correctly
>> >
>> >The reason is that it lacks a subject.
>> 
>> "current offset" is your subject.
>
>In my school we were taught that "current offset" is part of the
>predicate as opposed to the subject.  This can be seen from the
>fact that "offset" is singular while "initialise" did not take
>on its third-person singular form of "initialises".

o_O  I better continue believing it is the subject. Because with
one extra word at the front, you can make this a "complete sentence":

	Please initialize [the] current offset in xfs_file_readdir.

;-)
