Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab0CCXIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 18:08:55 -0500
Received: from sh.osrg.net ([192.16.179.4]:47350 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab0CCXIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 18:08:47 -0500
Date: Thu, 4 Mar 2010 08:08:37 +0900
To: randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: mmotm 2010-03-02-18-38 uploaded (dma unmapping)
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4B8EB65F.9060800@oracle.com>
References: <201003030305.o2335F1F015917@imap1.linux-foundation.org>
	<4B8EB65F.9060800@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100304080822V.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 04 Mar 2010 08:08:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Mar 2010 11:19:59 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On 03/02/10 18:39, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2010-03-02-18-38 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://zen-kernel.org/kernel/mmotm.git
> > 
> > It contains the following patches against 2.6.33:
> 
> 
> 
> drivers/net/chelsio/sge.c:164: error: expected specifier-qualifier-list before 'DECLARE_DMA_UNMAP_ADDR'
> drivers/net/chelsio/sge.c:170: error: expected specifier-qualifier-list before 'DECLARE_DMA_UNMAP_ADDR'
> 
> drivers/infiniband/hw/amso1100/c2_mq.h:74: error: expected specifier-qualifier-list before 'DECLARE_DMA_UNMAP_ADDR'
> drivers/infiniband/hw/amso1100/c2_provider.h:53: error: expected specifier-qualifier-list before 'DECLARE_DMA_U
> NMAP_ADDR'
> 
> drivers/net/cxgb3/sge.c:120: error: expected specifier-qualifier-list before 'DECLARE_DMA_UNMAP_ADDR'
> drivers/net/cxgb3/sge.c:210: error: expected specifier-qualifier-list before 'DECLARE_DMA_UNMAP_ADDR'

Sorry. I can't reproduce this here. Can you send .config?
