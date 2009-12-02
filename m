Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbZLBIhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbZLBIhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbZLBIhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:37:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53934
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752755AbZLBIhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:37:13 -0500
Date: Wed, 02 Dec 2009 00:37:19 -0800 (PST)
Message-Id: <20091202.003719.233698986.davem@davemloft.net>
To: Jie.Yang@Atheros.com
Cc: ben@decadent.org.uk, 558426@bugs.debian.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next]atl1e:disable NETIF_F_TSO6 for hardware limit
From: David Miller <davem@davemloft.net>
In-Reply-To: <72981EBCFD196144B7C6999B9FC34A9A494C6DABC3@SHEXMB-01.global.atheros.com>
References: <1259723914457-git-send-email-jie.yang@atheros.com>
	<20091202.003151.77443093.davem@davemloft.net>
	<72981EBCFD196144B7C6999B9FC34A9A494C6DABC3@SHEXMB-01.global.atheros.com>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Yang <Jie.Yang@Atheros.com>
Date: Wed, 2 Dec 2009 16:34:18 +0800

> On Wednesday, December 02, 2009 4:32 PM
> David Miller <davem@davemloft.net> wrote:
>>
>> From: <jie.yang@atheros.com>
>> Date: Wed, 2 Dec 2009 11:18:34 +0800
>>
>> > From: Jie Yang <jie.yang@atheros.com>
>> >
>> > For hardware limit to support TSOV6, just disable this feature
>> > Signed-off-by: Jie Yang <jie.yang@atheros.com>
>>
>> Shouldn't we be applying this to net-2.6 since it's a bug fix?
>>
> oh, It should applying to net-2.6.

Great, that's where I've applied it.

Thanks.
