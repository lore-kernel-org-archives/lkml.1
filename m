Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbXEWHQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbXEWHQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbXEWHQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:16:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40864
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756729AbXEWHQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:16:08 -0400
Date: Wed, 23 May 2007 00:16:08 -0700 (PDT)
Message-Id: <20070523.001608.101595297.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Introduce CONFIG_VIRT_TO_BUS
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070523170155.2cb9eff8.sfr@canb.auug.org.au>
References: <20070523170155.2cb9eff8.sfr@canb.auug.org.au>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 23 May 2007 17:01:55 +1000

> Make some offending drivers depend on it and set
> CONFIG_ARCH_NO_VIRT_TO_BUS for ppc64 so that we don't build those drivers.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Acked-by: David S. Miller <davem@davemloft.net>

Thank you, feel free to set it on sparc64 too.
