Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbZHJUOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbZHJUOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbZHJUOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:14:33 -0400
Received: from smtp2.caviumnetworks.com ([209.113.159.134]:14955 "EHLO
	smtp2.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbZHJUOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:14:33 -0400
X-Greylist: delayed 1018 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Aug 2009 16:14:32 EDT
Message-ID: <4A807BAD.5010708@caviumnetworks.com>
Date: Mon, 10 Aug 2009 12:57:33 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-mips <linux-mips@linux-mips.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] New hardware RNG for Octeon SOCs.
References: <4A806529.3060609@caviumnetworks.com> <1249934094.3807.32.camel@calx>
In-Reply-To: <1249934094.3807.32.camel@calx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2009 19:57:33.0928 (UTC) FILETIME=[CD394E80:01CA19F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Mon, 2009-08-10 at 11:21 -0700, David Daney wrote:
>> Behold the Random Number Generator driver for Octeon!
>>
>> The first patch adds some port definitions and the octeon_rng platform
>> device.  The second is the driver.
>>
>> I am copying AKPM and Linus as there seems to be no hw_random maintainer.
> 
> These now go through Herbert Xu and I.

I had been advised of this after I sent the messages.  Perhaps an entry 
in MAINTAINERS is in order.

David Daney
