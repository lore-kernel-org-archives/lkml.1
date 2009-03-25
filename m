Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbZCYXDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbZCYXDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 19:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZCYXDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 19:03:14 -0400
Received: from cpe-72-225-45-7.rochester.res.rr.com ([72.225.45.7]:38879 "EHLO
	death.krwtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZCYXDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 19:03:13 -0400
X-Greylist: delayed 2521 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Mar 2009 19:03:12 EDT
Date: Wed, 25 Mar 2009 18:20:00 -0400 (EDT)
From: Ken Witherow <ken@krwtech.com>
Reply-To: Ken Witherow <ken@krwtech.com>
To: Ingo Molnar <mingo@elte.hu>
cc: Herbert Xu <herbert@gondor.apana.org.au>,
       David Miller <davem@davemloft.net>, r.schwebel@pengutronix.de,
       torvalds@linux-foundation.org, blaschka@linux.vnet.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
In-Reply-To: <20090325220149.GB21111@elte.hu>
Message-ID: <Pine.LNX.4.64.0903251816310.31164@death.krwtech.com>
References: <20090324150928.GB30224@gondor.apana.org.au>
 <20090324.143622.186562202.davem@davemloft.net> <20090325002303.GA2219@gondor.apana.org.au>
 <20090324.191134.05205089.davem@davemloft.net> <20090325073349.GF25833@elte.hu>
 <20090325120840.GA6351@gondor.apana.org.au> <20090325122046.GD11571@elte.hu>
 <20090325122635.GA6489@gondor.apana.org.au> <20090325220149.GB21111@elte.hu>
Organization: KRW Technologies
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009, Ingo Molnar wrote:

>
> * Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
>> On Wed, Mar 25, 2009 at 01:20:46PM +0100, Ingo Molnar wrote:
>>>
>>> ok - i have started testing the delta below, on top of the plain
>>> revert.
>
> it's still fine btw, so:
>
> Tested-by: Ingo Molnar <mingo@elte.hu>

I saw your patch this morning and added it to my system too. 4 hours and 
15 minutes and everything is still fine here.



CONFIG_FORCEDETH=y
# CONFIG_FORCEDETH_NAPI is not set

with

00:08.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a3)
