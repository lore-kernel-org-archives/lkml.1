Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbYDYHm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbYDYHm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 03:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbYDYHmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 03:42:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:28870 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570AbYDYHmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 03:42:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=maMGGZas2qNWFpWoZR0bJ6DeXxGlnLaXgOWGcBDfzVyHC66cpOnVPiqIuuybMM2aGCj5fq+OM6F0TSis2Sjumxbk45yfxg72RD0z2xXnEFUd0B4sObzBZacLPUmCJVgdXAGyYJ+0h+ayntRHaVQW/66dKY8iJIHXY+AWNJOMurs=
Message-ID: <48118B73.6000700@gmail.com>
Date: Fri, 25 Apr 2008 09:42:43 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: torvalds@linux-foundation.org, zdenek.kabelac@gmail.com, mingo@elte.hu,
       rjw@sisk.pl, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi, clameter@sgi.com
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
References: <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com>	<alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org>	<4811090A.9030809@gmail.com> <20080424.183558.96469288.davem@davemloft.net>
In-Reply-To: <20080424.183558.96469288.davem@davemloft.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2008 03:35 AM, David Miller wrote:
> From: Jiri Slaby <jirislaby@gmail.com>
> Date: Fri, 25 Apr 2008 00:26:18 +0200
> 
>> ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadccf0 
> 
> 0xf0...  Is this a 4-cpu machine?

It's a 2 cores machine.

> I doubt it, because this is on a laptop as far as I can tell,
> but I thought I'd ask. :-)

Well, it's not :), it's a desktop.

		Jiri
