Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbZKLCzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbZKLCzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 21:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760039AbZKLCzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 21:55:54 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:36664 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759999AbZKLCzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 21:55:54 -0500
Message-ID: <4AFB7935.8010204@gmail.com>
Date: Thu, 12 Nov 2009 03:55:49 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: net tree build warning
References: <20091112132424.e010e3c5.sfr@canb.auug.org.au> <20091111.185338.253345558.davem@davemloft.net>
In-Reply-To: <20091111.185338.253345558.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 12 Nov 2009 03:55:52 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller a écrit :
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 12 Nov 2009 13:24:24 +1100
> 
>> Hi Dave,
>>
>> Today's linux-next build (x86_64 allmodconfig) produced this warning:
>>
>> net/ipv6/addrconf.c: In function 'inet6_dump_ifinfo':
>> net/ipv6/addrconf.c:3833: warning: unused variable 'err'
>>
>> Introduced by commit 84d2697d9649339215675551eae28ba04068dea1 ("ipv6:
>> speedup inet6_dump_ifinfo()").
> 
> I just pushed a fix for this into net-next-2.6, thanks!

You beat me :)

Thanks

