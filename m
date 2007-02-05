Return-Path: <linux-kernel-owner+w=401wt.eu-S933461AbXBEVbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461AbXBEVbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933475AbXBEVbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:31:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56562
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933460AbXBEVbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:31:38 -0500
Date: Mon, 05 Feb 2007 13:31:37 -0800 (PST)
Message-Id: <20070205.133137.126764360.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org, akpm@osdl.org
Subject: Re: [PATCH] Include missing header in include/asm-sparc64/tlb.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070205175714.GA8341@Krystal>
References: <20070205175714.GA8341@Krystal>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Mon, 5 Feb 2007 12:57:14 -0500

> Include missing header in include/asm-sparc64/tlb.h
> 
> sparc64 does not compile without this. It applies on 2.6.20.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

It builds perfectly fine for me with several different config variants
without adding this include.

Please provide the build failure messages and your kernel config so
this can be properly analyzed, thank you.
