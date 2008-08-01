Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbYHAHE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbYHAHE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 03:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbYHAHES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 03:04:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48613
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753308AbYHAHER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 03:04:17 -0400
Date: Fri, 01 Aug 2008 00:04:17 -0700 (PDT)
Message-Id: <20080801.000417.85699799.davem@davemloft.net>
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, sfr@canb.auug.org.au,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org, mingo@elte.hu,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH] Revert "Merge branch 'x86/iommu' of
 git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip into
 for-linus"
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080801070328.GA26894@amd.com>
References: <20080801094323.9601d87b.sfr@canb.auug.org.au>
	<20080801085106E.fujita.tomonori@lab.ntt.co.jp>
	<20080801070328.GA26894@amd.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>
Date: Fri, 1 Aug 2008 09:03:28 +0200

> That may be the reason that your fix is not yet upstream.

The reason is more-so because Linus simply hasn't merged more
than a couple of patches since 2.6.27-rc1 was released.
