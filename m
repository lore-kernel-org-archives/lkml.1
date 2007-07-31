Return-Path: <linux-kernel-owner+w=401wt.eu-S940290AbXGaBF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940290AbXGaBF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 21:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938768AbXGaBFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 21:05:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49861
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S938707AbXGaBFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 21:05:14 -0400
Date: Mon, 30 Jul 2007 18:05:07 -0700 (PDT)
Message-Id: <20070730.180507.101870991.davem@davemloft.net>
To: bunk@stusta.de
Cc: yasuyuki.kozakai@toshiba.co.jp, kaber@trash.net,
       netfilter-devel@lists.netfilter.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make nf_ct_ipv6_skip_exthdr() static
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070729145846.GZ16817@stusta.de>
References: <20070729145846.GZ16817@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Date: Sun, 29 Jul 2007 16:58:46 +0200

> nf_ct_ipv6_skip_exthdr() can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Applied.
