Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab0BDEDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 23:03:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45718
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756772Ab0BDEDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 23:03:49 -0500
Date: Wed, 03 Feb 2010 20:04:02 -0800 (PST)
Message-Id: <20100203.200402.17600564.davem@davemloft.net>
To: jkosina@suse.cz
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, lsorense@csclub.uwaterloo.ca,
       netdev@vger.kernel.org, daniel@caiaq.de
Subject: Re: linux-next: manual merge of the trivial tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1002031136560.15395@pobox.suse.cz>
References: <20100203133011.75aef1d3.sfr@canb.auug.org.au>
	<alpine.LNX.2.00.1002031136560.15395@pobox.suse.cz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Wed, 3 Feb 2010 11:39:47 +0100 (CET)

> I think the best thing is me dropping the net/ and drivers/net hunks of 
> this patch and taking it through Davem's tree ... I have already dropped 
> those hunks from my tree. Dave, the patch is below, please consider 
> applying.
 ...
> From: Daniel Mack <daniel@caiaq.de>
> Subject: [PATCH] net: fix 'lenght' typo in comments and code
> 
> Some misspelled occurences of 'octet' and some comments were also fixed
> as I was on it.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Jiri Kosina <trivial@kernel.org>
> Cc: Joe Perches <joe@perches.com>
> Cc: Junio C Hamano <gitster@pobox.com>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

This doesn't apply to net-next-2.6 at all:

error: patch failed: drivers/net/ppp_generic.c:1436
error: drivers/net/ppp_generic.c: patch does not apply
error: drivers/net/stmmac/gmac.c: does not exist in index
error: drivers/net/stmmac/mac100.c: does not exist in index
