Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbZC3MBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbZC3MBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbZC3MBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:01:00 -0400
Received: from stinky.trash.net ([213.144.137.162]:59276 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbZC3MA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:00:59 -0400
Message-ID: <49D0B476.2000607@trash.net>
Date: Mon, 30 Mar 2009 14:00:54 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: pablo@netfilter.org, gorcunov@gmail.com, randy.dunlap@oracle.com,
       sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org
Subject: Re: linux-next: Tree for March 27 (netfilter build error)
References: <20090329064704.GA7255@localhost>	<20090328.234739.26481917.davem@davemloft.net>	<49CF62A2.6050803@netfilter.org> <20090329.134614.198823811.davem@davemloft.net>
In-Reply-To: <20090329.134614.198823811.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Sun, 29 Mar 2009 13:59:30 +0200
> 
>> David Miller wrote:
>>> From: Cyrill Gorcunov <gorcunov@gmail.com>
>>> Date: Sun, 29 Mar 2009 10:47:04 +0400
>>>
>>>> [Randy Dunlap - Sat, Mar 28, 2009 at 09:26:42PM -0700]
>>>> ... 
>>>> | works_for_me.  Thanks.
>>>> | but missing S-O-B.
>>>> | 
>>>> | Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
>>>> ...
>>>>
>>>> Thanks for testing Randy. So if nobody will complain
>>>> here is a solid version of the patch. Though I would like
>>>> if Pablo or Patrick confirm its correctness. Thanks!
>>> I'll apply this once Patrick or Pablo have a look at it.
>> I think that the patch attached is better since it removes the overhead
>> of the IPv6 dependency, which is indeed too much for the use of one
>> function. Thanks.
> 
> I think it's a lot better too, applied, thanks!

No objections from my side, thanks :)


