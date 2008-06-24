Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbYFXFKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbYFXFKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 01:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbYFXFJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 01:09:50 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5915 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbYFXFJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 01:09:48 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5323"; a="4170954"
Message-ID: <4860819A.4030809@qualcomm.com>
Date: Mon, 23 Jun 2008 22:09:46 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: wcang@nav6.org, steve.zabele@baesystems.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NET: Proper handling of IPv6 header in tun driver when
 TUN_NO_PI is set
References: <48499C32.6070703@qualcomm.com>	<20080617.163205.160864233.davem@davemloft.net>	<48586F4B.4060404@nav6.org> <20080617.210803.190930256.davem@davemloft.net>
In-Reply-To: <20080617.210803.190930256.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Ang Way Chuang <wcang@nav6.org>
> Date: Wed, 18 Jun 2008 10:13:31 +0800
> 
>> David Miller wrote:
>>> From: Max Krasnyanskiy <maxk@qualcomm.com>
>>> Date: Fri, 06 Jun 2008 13:21:06 -0700
>>>
>>>> Acked-by: Max Krasnyansky <maxk@qualcomm.com>
>>>>
>>>> Dave, can you please add this patch to your tree.
>>> I can't, the patch is severely whitespace damaged.
>>>
>> Resend. Hopefully Thunderbird won't screw this time.
> 
> Same problem, tabs were transformed into spaces, and
> lines composed of only whitespace were transformed into
> empty lines.
> 
> This is frustrating enough, I'm just going to fix this up
> by hand for you, but please get your shit straight for next
> time because I won't do this twice.

Dave, thanks a lot for fixing this up. I looked at the patch and logic wise it
looked perfectly fine. I did not notice the problem with the spaces. Sorry.

Max
