Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbYHAHXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbYHAHXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 03:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYHAHXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 03:23:00 -0400
Received: from sh.osrg.net ([192.16.179.4]:42817 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbYHAHXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 03:23:00 -0400
Date: Fri, 1 Aug 2008 16:21:21 +0900
To: davem@davemloft.net
Cc: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, sfr@canb.auug.org.au,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org, mingo@elte.hu,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH] Revert "Merge branch 'x86/iommu' of
 git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip into
 for-linus"
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080801.000417.85699799.davem@davemloft.net>
References: <20080801085106E.fujita.tomonori@lab.ntt.co.jp>
	<20080801070328.GA26894@amd.com>
	<20080801.000417.85699799.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080801162109Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Aug 2008 00:04:17 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Fri, 1 Aug 2008 09:03:28 +0200
> 
> > That may be the reason that your fix is not yet upstream.
> 
> The reason is more-so because Linus simply hasn't merged more
> than a couple of patches since 2.6.27-rc1 was released.

Yeah, I think so.

I'll send the patch to Linus if necessary.
