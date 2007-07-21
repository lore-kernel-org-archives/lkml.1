Return-Path: <linux-kernel-owner+w=401wt.eu-S1763681AbXGULRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763681AbXGULRt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 07:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760795AbXGULRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 07:17:41 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53856 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760569AbXGULRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 07:17:40 -0400
Date: Sat, 21 Jul 2007 13:18:08 +0200
From: Sebastian Siewior <sebastian@breakpoint.cc>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2o: defined but not used.
Message-ID: <20070721111808.GA9145@ayoka.breakpoint.cc>
References: <20070720225817.607502287@ayoka.breakpoint.cc> <20070721033133.ed47aa6a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070721033133.ed47aa6a.akpm@linux-foundation.org>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Breakpoint-Spam-Score: -1.4
X-Breakpoint-Spam-Level: -
X-Breakpoint-Spam-Status: No , -1.4 points, 5.0 required,  ALL_TRUSTED=-1.44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton | 2007-07-21 03:31:33 [-0700]:

>On Sat, 21 Jul 2007 00:58:01 +0200 Sebastian Siewior <sebastian@breakpoint.cc> wrote:
>
>> Got with randconfig
>
>randconfig apparently generates impossible configs.  Please always
>run `make oldconfig' after the randconfig, then do the test build.

Ah okey, I did not know this. 

CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set

Is still in my .config after oldconfig.

Sebastian

