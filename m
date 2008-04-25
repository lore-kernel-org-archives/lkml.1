Return-Path: <linux-kernel-owner+w=401wt.eu-S1759812AbYDYIA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759812AbYDYIA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 04:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYDYIAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 04:00:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:5607 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758584AbYDYIAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 04:00:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=grtQDF0YtBT/lgU4L7xgVkCjysrWM7Y8H4RGYYExuJZbBRBFilAgP9YEFtGbDguCGVRZKUkOzM/ni7DRhu7s/flP0gxL6vRfRF2u1zSoKtWL39Y9HiC6GPuKHbgGvJ1dCAACNee8H+KXBUwdSnoT9GvC9dUUaB/vyQyXzLUmyKs=
Message-ID: <48118F85.4060703@gmail.com>
Date: Fri, 25 Apr 2008 10:00:05 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: torvalds@linux-foundation.org, zdenek.kabelac@gmail.com, mingo@elte.hu,
       rjw@sisk.pl, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi, clameter@sgi.com
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
References: <48118B73.6000700@gmail.com>	<20080425.004943.148536408.davem@davemloft.net>	<48118EAB.5040004@gmail.com> <20080425.005816.249606540.davem@davemloft.net>
In-Reply-To: <20080425.005816.249606540.davem@davemloft.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2008 09:58 AM, David Miller wrote:
>>> If so that could match up to the pattern.  It is just one theory
>>> though.  The wireless possibility holds just as much weight.
>> The mac80211 is theory too so far :).
> 
> I'll try to do some commit mining of my own.

BTW Doesn't exist any tool to compare diffs? Particularly 
2.6.28-rc8-mm1..2.6.28-rc8-mm2 with 2.6.25..2.6.25-git2... I would just give it 
a try.
