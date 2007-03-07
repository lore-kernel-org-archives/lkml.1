Return-Path: <linux-kernel-owner+w=401wt.eu-S2992448AbXCGSVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992448AbXCGSVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992445AbXCGSVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:21:22 -0500
Received: from nz-out-0506.google.com ([64.233.162.228]:48254 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992448AbXCGSVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:21:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Kw177zoqPRaxRONZIgSSeQ3RPfXj5UZ4/07LOeFvZhcXjnfiz3fbhMZL/Tx0huQ4odYdtcm2P5bxsxFEzWya9GOnEg2H4P6FvqTzPOCgsBeZ59pHBHzRE0Zhj1vM1/fR4tJsdDOPf/e8yQBG8IUYKv0d7YXrhs5H2Adkgx3u8fE=
Message-ID: <ca9528de0703071021t2aeb19d9ve537b0447cfd310@mail.gmail.com>
Date: Wed, 7 Mar 2007 15:21:19 -0300
From: "Kirk Kuchov" <kirk.kuchov@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: "Pavel Machek" <pavel@ucw.cz>, "Davide Libenzi" <davidel@xmailserver.org>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Eric Dumazet" <dada1@cosmosbay.com>, "Theodore Tso" <tytso@mit.edu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Zach Brown" <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070307173953.GA27603@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703020840120.1977@alien.or.mcafeemobile.com>
	 <Pine.LNX.4.64.0703030945030.7075@alien.or.mcafeemobile.com>
	 <20070303203140.GA756@2ka.mipt.ru>
	 <Pine.LNX.4.64.0703031248450.7278@alien.or.mcafeemobile.com>
	 <ca9528de0703040823x340b0b7fw923b9bae8bcf0e7@mail.gmail.com>
	 <Pine.LNX.4.64.0703041129550.3300@alien.or.mcafeemobile.com>
	 <ca9528de0703041449x695a4c4bpc133d9afd5524019@mail.gmail.com>
	 <20070306081935.GB2040@elf.ucw.cz>
	 <ca9528de0703070402r3d189348t78d27cf3b80b4623@mail.gmail.com>
	 <20070307173953.GA27603@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Kirk Kuchov <kirk.kuchov@gmail.com> wrote:
>
> > I don't believe I'm wasting my time explaining this. They don't exist
> > as /dev/null, they are just fucking _LINKS_.
> [...]
> > > Either stop flaming kernel developers or become one. It is that
> > > simple.
> >
> > If I were to become a kernel developer I would stick with FreeBSD.
> > [...]
>
> Hey, really, this is an excellent idea: what a boon you could become to
> FreeBSD, again! How much they must be longing for your insightful
> feedback, how much they must be missing your charming style and tactful
> approach! I bet they'll want to print your mails out, frame them and
> hang them over their fireplace, to remember the good old days on cold
> snowy winter days, with warmth in their hearts! Please?
>

http://www.totallytom.com/thecureforgayness.html

--
Kirk Kuchov
