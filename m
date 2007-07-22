Return-Path: <linux-kernel-owner+w=401wt.eu-S1758578AbXGVCK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbXGVCK5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 22:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbXGVCKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 22:10:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52315
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755866AbXGVCK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 22:10:28 -0400
Date: Sat, 21 Jul 2007 19:10:27 -0700 (PDT)
Message-Id: <20070721.191027.32096386.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org, paulus@samba.org,
       wli@holomorphy.com
Subject: Re: [PATCH] constify of_platform_driver match_table
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070722002701.77622474.sfr@canb.auug.org.au>
References: <20070722002701.77622474.sfr@canb.auug.org.au>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Sun, 22 Jul 2007 00:27:01 +1000

> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  include/linux/of_platform.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Built for PowerPC allmodconfig and ppc64_defconfig and Sparc and Sparc64
> defconfig.

Acked-by: David S. Miller <davem@davemloft.net>
