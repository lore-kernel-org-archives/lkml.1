Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab0BOH0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 02:26:01 -0500
Received: from sh.osrg.net ([192.16.179.4]:59664 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537Ab0BOHZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 02:25:59 -0500
Date: Mon, 15 Feb 2010 16:25:14 +0900
To: Larry.Finger@lwfinger.net
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, mb@bu3sch.de, davem@davemloft.net,
       stefano.brivio@polimi.it, akpm@linux-foundation.org
Subject: Re: [PATCH -mm] ssb: open-code dma_alloc_coherent
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4B78EE6A.3010207@lwfinger.net>
References: <20100215142111R.fujita.tomonori@lab.ntt.co.jp>
	<4B78EE6A.3010207@lwfinger.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100215162426V.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 15 Feb 2010 16:25:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Feb 2010 00:49:14 -0600
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> On 02/14/2010 11:21 PM, FUJITA Tomonori wrote:
> > This patch is against -mm since it depends on the DMA API changes in
> > -mm.
> 
> Are the patches that implement these DMA API changes available for testing? I
> don't keep an -mm tree.

All the patches are in -mm and I've just uploaded the patches against
2.6.33-rc8:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git pending

The ssb patch depends on the latest eight patches in the tree:

http://marc.info/?l=linux-kernel&m=126596737604808&w=2



Thanks!
