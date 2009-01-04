Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbZADIdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbZADIdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 03:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbZADIdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 03:33:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55640 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbZADIdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 03:33:41 -0500
Message-ID: <496073AB.2030400@cn.fujitsu.com>
Date: Sun, 04 Jan 2009 16:30:35 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org
Subject: Re: [RFC, PATCH] kernel/rcu: add kfree_rcu
References: <200901021159.n02BxDLg024728@mail.q-ag.de> <49604BAD.5010405@cn.fujitsu.com> <4960603F.2030002@colorfullife.com>
In-Reply-To: <4960603F.2030002@colorfullife.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manfred Spraul wrote:
> Lai Jiangshan wrote:
>> Hi, Manfred Spraul,
>>
>> Thanks you for re-propose kfree_rcu().
>> I NAK. this patch.
>>
>> Comparing with my patch(V1), your patch has several improvements.
>> But core idea is the same as my patch.
>> This idea(share offset with function pointer) has some disadvantages.
>> And I had implemented V2 and the patches for using kfree_rcu().
>> The V2 patch has not tested enough, but It will be done in one month.
>>   
> Did you already post V2, did you cc me?
> I couldn't find it in my e-mails.
> 

I have not posted it. -:)

Lai




