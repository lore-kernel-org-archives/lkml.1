Return-Path: <linux-kernel-owner+w=401wt.eu-S1757158AbYGOCbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158AbYGOCbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbYGOCbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:31:05 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:49375 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbYGOCbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:31:03 -0400
Message-ID: <487C0C52.9030000@keyaccess.nl>
Date: Tue, 15 Jul 2008 04:32:50 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: david@lang.hm, torvalds@linux-foundation.org, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm>	<20080714.185207.203328391.davem@davemloft.net>	<487C0A12.9060906@keyaccess.nl> <20080714.192425.241878700.davem@davemloft.net>
In-Reply-To: <20080714.192425.241878700.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-07-08 04:24, David Miller wrote:

> From: Rene Herman <rene.herman@keyaccess.nl>
> Date: Tue, 15 Jul 2008 04:23:14 +0200
> 
>> On 15-07-08 03:52, David Miller wrote:
>>
>>> From: david@lang.hm Date: Mon, 14 Jul 2008 17:51:37 -0700 (PDT)
>>>
>>>> I agree with this, but the proponents of the seperate firmware are
>>>> listing the fact that the firmware doesn't tie up ram as one of the
>>>> big reasons for making the change.
>>> Exactly.
>>>
>>> Otherwise these firmware changes are utterly pointless.
>> The point of them is legal.
> 
> Thanks for proving something I tried to establish for weeks
> but which Alan Cox, David W., and others vehemently denied.
> 
> They states that it was being done on a technical basis rather
> than being predominantly a legal one.

Yes, they were obstinate or dishonest (I won't say "respectively"). As 
to "proving" though, I cannot prove anything, being a mere observer.

At this point I really believe this discussion should be about the other 
part of my reply -- the point mostly put forward by Jef Garzik about the 
firmware inside the module image. Without that ability, I don't believe 
these are good patches.

_With_ that ability, I myself do. Let's allow allow everyone their own 
level of fear, uncertainty and doubt.

Rene

