Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbXGRHKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbXGRHKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 03:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbXGRHJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 03:09:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50966
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752199AbXGRHJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 03:09:51 -0400
Date: Wed, 18 Jul 2007 00:09:48 -0700 (PDT)
Message-Id: <20070718.000948.112288343.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: wli@holomorphy.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH] Mark sparc and sparc64 as not having virt_to_bus
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070718144140.3b4fd82e.sfr@canb.auug.org.au>
References: <20070718144140.3b4fd82e.sfr@canb.auug.org.au>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 18 Jul 2007 14:41:40 +1000

> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/sparc/Kconfig       |    3 +++
>  arch/sparc64/Kconfig     |    3 +++
>  include/asm-sparc64/io.h |    5 -----
>  3 files changed, 6 insertions(+), 5 deletions(-)
> 
> This is part of a rash attempt to make allmodconfig builds work for sparc
> and sparc64 :-)

Hehe, applied, thanks Stephen.
