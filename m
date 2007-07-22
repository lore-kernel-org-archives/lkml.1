Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbXGVCTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbXGVCTW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 22:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbXGVCTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 22:19:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34706
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753388AbXGVCTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 22:19:13 -0400
Date: Sat, 21 Jul 2007 19:19:12 -0700 (PDT)
Message-Id: <20070721.191912.07278915.davem@davemloft.net>
To: viro@ftp.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] clean include/asm-sparc/irq.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1ICNRU-0000lJ-Eo@ZenIV.linux.org.uk>
References: <E1ICNRU-0000lJ-Eo@ZenIV.linux.org.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 21 Jul 2007 23:28:52 +0100

> 
> Move stuff used only by arch/sparc/kernel/* into arch/sparc/kernel/irq.h
> and into individual files in there (e.g. macros internal to sun4m_irq.c,
> etc.)
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Applied, thanks Al.
