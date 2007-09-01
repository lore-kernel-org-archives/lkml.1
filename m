Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbXIANxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbXIANxM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 09:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbXIANxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 09:53:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51514 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbXIANxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 09:53:00 -0400
Message-ID: <46D96EB4.6010704@garzik.org>
Date: Sat, 01 Sep 2007 09:52:52 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
References: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain> <Pine.LNX.4.64.0709010648530.32589@localhost.localdomain> <46D947A3.1000404@garzik.org> <200709011544.07732.bzolnier@gmail.com>
In-Reply-To: <200709011544.07732.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Saturday 01 September 2007, you wrote:
>> Robert P. J. Day wrote:
>>> On Sat, 1 Sep 2007, Jeff Garzik wrote:
>>>
>>>> Feature deprecation and removal is a very amorphous concept that
>>>> does not fit well at all into Kconfig markers, unlike
>>>> experimental/broken.
> 
> The current approach (text file) is:
> * centralized
> * requires manual testing of all future changes
> * totally invisible to the end-users (higly frustrating for them when
>   they learn about scheduled changes when things brake)
> 
> The proposed approach (Kconfig) is:
> * distributed
> * allows partial automatic testing of future changes
> * could be make visible to the end-users by smart use of macros/inlines
>   and adding kernel parameter (would make users informed and encourage
>   them to help with the development)
> 
>>> and, as i've said before, i disagree.  while one might debate what
>> Feel free to disagree -- I am describing how things play out on a day to 
>> day basis.  In essence you are disagreeing with reality.
> 
> Part of the problem is that many people (including developers) learn about
> things being deprecated/obsoleted after they are actually removed.
> 
> Of course things are not black and white and common sense is required but
> moving in the Kconfig direction is an improvement IMO and could speed up
> the development in the long-term.
> 
> BTW There is nothing wrong with disagreeing with the reality and trying
> to change it.  If everybody would conform to the reality there will be no
> progress at all... ;)

I have --no problem-- with changes that enable people to disable 
deprecated/obsolete stuff, just like experimental and broken stuff.

I do have a problem with mischaracterization of today's reality.

	Jeff



