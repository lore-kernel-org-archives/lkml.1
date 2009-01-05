Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbZAECve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbZAECve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 21:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbZAECvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 21:51:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54510 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbZAECvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 21:51:12 -0500
Message-ID: <496174EB.4030601@cn.fujitsu.com>
Date: Mon, 05 Jan 2009 10:48:11 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [RFC, PATCH] kernel/rcu: add kfree_rcu
References: <200901021159.n02BxDLg024728@mail.q-ag.de> <20090102185543.GE6842@linux.vnet.ibm.com> <49604E19.8040502@cn.fujitsu.com> <20090104194851.GM6958@linux.vnet.ibm.com>
In-Reply-To: <20090104194851.GM6958@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> 
> In any case, I do apologize -- since I didn't see anything from you I
> incorrectly assumed that you had given up on this patch.  Please accept
> my apologies!

It's my fault.

I'm a very low-yield developer.

I have given up on unaccepted cleanup-patches, kfree_rcu() is not a
cleanup for reducing lines of code, it has some significances for kernel.

> 
> Would it be possible for you and Manfred to agree on a common patch, and
> to have one of you submit it with both of you having Signed-off-by on it?
>
All are OK.

I NAK-ed only for deferring kfree_rcu() being accepted.

I'm not concerned about whether I'm patches' Author or I'm in the
Signed-off-by list.

Thanks,

Lai.

