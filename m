Return-Path: <linux-kernel-owner+w=401wt.eu-S933903AbXGQPGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903AbXGQPGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbXGQPGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:06:01 -0400
Received: from stinky.trash.net ([213.144.137.162]:46588 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbXGQPGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:06:00 -0400
Message-ID: <469CDAD0.4000804@trash.net>
Date: Tue, 17 Jul 2007 17:05:52 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: davem@davemloft.net, netdev@vger.kernel.org,
       netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
       cilly <cilly@cilly.mine.nu>
Subject: Re: [2.6 patch] ipt_iprange.h must #include <linux/types.h>
References: <20070715121419.GK3565@stusta.de>
In-Reply-To: <20070715121419.GK3565@stusta.de>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> ipt_iprange.h must #include <linux/types.h> since it uses __be32.


Applied, thanks.
