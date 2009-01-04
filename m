Return-Path: <linux-kernel-owner+w=401wt.eu-S1752908AbZADHHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbZADHHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 02:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbZADHHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 02:07:40 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:43852 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZADHHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 02:07:40 -0500
Message-ID: <4960603F.2030002@colorfullife.com>
Date: Sun, 04 Jan 2009 08:07:43 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org
Subject: Re: [RFC, PATCH] kernel/rcu: add kfree_rcu
References: <200901021159.n02BxDLg024728@mail.q-ag.de> <49604BAD.5010405@cn.fujitsu.com>
In-Reply-To: <49604BAD.5010405@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> Hi, Manfred Spraul,
>
> Thanks you for re-propose kfree_rcu().
> I NAK. this patch.
>
> Comparing with my patch(V1), your patch has several improvements.
> But core idea is the same as my patch.
> This idea(share offset with function pointer) has some disadvantages.
> And I had implemented V2 and the patches for using kfree_rcu().
> The V2 patch has not tested enough, but It will be done in one month.
>   
Did you already post V2, did you cc me?
I couldn't find it in my e-mails.

--
    Manfred
