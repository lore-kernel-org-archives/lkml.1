Return-Path: <linux-kernel-owner+w=401wt.eu-S1760827AbXGDLuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760827AbXGDLuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 07:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758604AbXGDLu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 07:50:27 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:38298 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757712AbXGDLu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 07:50:26 -0400
Message-ID: <468B8952.9030205@bx.jp.nec.com>
Date: Wed, 04 Jul 2007 20:49:38 +0900
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>,
       Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC][PATCH -mm 0/9] netconsole: Multiple targets and dynamic
 reconfigurability
References: <20070704110739.28520.5036.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070704110739.28520.5036.sendpatchset@cselinux1.cse.iitk.ac.in>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Satyam,
 
At first, thank you for your helping.
I'm going to try/review your patches.

>[ I had initially thought about only modifying Keiichi's patches to
>incorporate the suggested stuff, sysfs+ioctl->configfs conversion, etc,
>but the changes became too much and I ultimately ended up rewriting the
>patchset. This also gave the flexibility to make other changes possible.
>Keiichi, Takayoshi, kindly review this, and if OK, please give your
>Signed-off-by:'s to the patches herein. ]

By the way, how can I add Signed-off-by:'s to your patches?
Should I add it to each patch and submit them to this list again?

Anybody could give me an advice?
-- 
Keiichi KII
NEC Corporation OSS Platform Development Division
E-mail: k-keiichi@bx.jp.nec.com
