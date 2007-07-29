Return-Path: <linux-kernel-owner+w=401wt.eu-S933517AbXG2POy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517AbXG2POy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932093AbXG2PB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:01:59 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:44159 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbXG2PB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:01:58 -0400
Message-ID: <46ACAB45.6080307@gmail.com>
Date: Sun, 29 Jul 2007 16:59:17 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
       Daniel Hazelton <dhazelton@enter.net>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Frank Kingswood <frank@kingswood-consulting.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jesper Juhl <jesper.juhl@gmail.com>, ck list <ck@vds.kolivas.org>,
       Paul Jackson <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge plans
 for 2.6.23]
References: <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>	 <46AA3680.4010508@gmail.com>	 <Pine.LNX.4.64.0707271239300.26221@asgard.lang.hm>	 <46AAEDEB.7040003@gmail.com>	 <Pine.LNX.4.64.0707280138370.32476@asgard.lang.hm>	 <46AB166A.2000300@gmail.com>	 <20070728122139.3c7f4290@the-village.bc.nu>	 <46AC4B97.5050708@gmail.com>	 <20070729141215.08973d54@the-village.bc.nu>	 <46AC9F2C.8090601@gmail.com> <2c0942db0707290758p39fef2e8o68d67bec5c7ba6ab@mail.gmail.com>
In-Reply-To: <2c0942db0707290758p39fef2e8o68d67bec5c7ba6ab@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2007 04:58 PM, Ray Lee wrote:

> On 7/29/07, Rene Herman <rene.herman@gmail.com> wrote:
>> On 07/29/2007 03:12 PM, Alan Cox wrote:

>>> More radically if anyone wants to do real researchy type work - how about
>>> log structured swap with a cleaner  ?

>> Right over my head. Why does log-structure help anything?
> 
> Log structured disk layouts allow for better placement of writeout, so
> that you cn eliminate most or all seeks. Seeks are the enemy when
> trying to get full disk bandwidth.
> 
> google on log structured disk layout, or somesuch, for details.

I understand what log structure is generally, but how does it help swapin?

Rene.
