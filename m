Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbXJ2DGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbXJ2DGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 23:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbXJ2DGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 23:06:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48823
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750848AbXJ2DGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 23:06:10 -0400
Date: Sun, 28 Oct 2007 20:06:12 -0700 (PDT)
Message-Id: <20071028.200612.179943206.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] Silence radeon_pm warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071029135911.ba1bfee2.sfr@canb.auug.org.au>
References: <20071029135911.ba1bfee2.sfr@canb.auug.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 29 Oct 2007 13:59:11 +1100

> drivers/video/aty/radeon_pm.c:30: warning: 'radeon_reinitialize_M10' declared 'static' but never defined
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Acked-by: David S. Miller <davem@davemloft.net>
