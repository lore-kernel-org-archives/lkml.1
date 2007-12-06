Return-Path: <linux-kernel-owner+w=401wt.eu-S1753734AbXLFLOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbXLFLOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 06:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbXLFLOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 06:14:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37373
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751461AbXLFLOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 06:14:34 -0500
Date: Thu, 06 Dec 2007 03:14:34 -0800 (PST)
Message-Id: <20071206.031434.179419183.davem@davemloft.net>
To: xiyou.wangcong@gmail.com
Cc: linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au, akpm@osdl.org,
       netdev@vger.kernel.org
Subject: Re: [Patch] net/xfrm/xfrm_policy.c: Some small improvements
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071206110123.GB2469@hacking>
References: <20071206110123.GB2469@hacking>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: WANG Cong <xiyou.wangcong@gmail.com>
Date: Thu, 6 Dec 2007 19:01:23 +0800

> 
> This patch contains the following changes.
> 
> 	- Use 'bool' instead of 'int' for booleans.
> 	- Use 'size_t' instead of 'int' for 'sizeof' return value.
> 	- Some style fixes.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David Miller <davem@davemloft.net>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

Normally I would let a patch like this sit in my mailbox
for a week and then delete it.

But this time I'll just let you know up front that I
don't see much value in this patch.  It is not a clear
improvement to replace int's with bool's in my mind and
the other changes are just whitespace changes.

And thus I can delete the patch from my mailbox
immediately :-)

Sorry.
