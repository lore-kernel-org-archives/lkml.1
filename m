Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbYEABai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbYEABai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 21:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYEABaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 21:30:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:38965 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbYEABa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 21:30:29 -0400
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>, htejun@gmail.com,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Emilian.Medve@Freescale.com, linuxppc-dev@ozlabs.org
Message-Id: <D069945D-A47A-4782-91B5-F3D4209F6003@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20080501111817.e0d19258.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH v2] [POWERPC] devres: Add devm_ioremap_flags()
Date: Wed, 30 Apr 2008 20:29:56 -0500
References: <Pine.LNX.4.64.0804301106010.22992@blarg.am.freescale.net> <20080501111817.e0d19258.sfr@canb.auug.org.au>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 30, 2008, at 8:18 PM, Stephen Rothwell wrote:
> On Wed, 30 Apr 2008 11:08:51 -0500 (CDT) Kumar Gala <galak@kernel.crashing.org 
> > wrote:
>>
>> +++ b/arch/powerpc/lib/devres.c
>> @@ -0,0 +1,33 @@
>> +#include <linux/device.h>	/* devres_*(), devm_ioremap_release() */
>> +#include <linux/io.h>		/* ioremap_flags() */
>> +#include <linux/module.h>	/* EXPORT_SYMBOL() */
>
> This file needs a copyright notice and license ...

agreed.  will add.

- k
