Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab0CCTWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:22:14 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:26037 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab0CCTWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:22:04 -0500
Message-ID: <4B8EB65F.9060800@oracle.com>
Date: Wed, 03 Mar 2010 11:19:59 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: mmotm 2010-03-02-18-38 uploaded (dma unmapping)
References: <201003030305.o2335F1F015917@imap1.linux-foundation.org>
In-Reply-To: <201003030305.o2335F1F015917@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B8EB6B4.00EE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/10 18:39, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2010-03-02-18-38 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.33:



drivers/net/chelsio/sge.c:164: error: expected specifier-qualifier-list before 'DECLARE_DMA_UNMAP_ADDR'
drivers/net/chelsio/sge.c:170: error: expected specifier-qualifier-list before 'DECLARE_DMA_UNMAP_ADDR'

drivers/infiniband/hw/amso1100/c2_mq.h:74: error: expected specifier-qualifier-list before 'DECLARE_DMA_UNMAP_ADDR'
drivers/infiniband/hw/amso1100/c2_provider.h:53: error: expected specifier-qualifier-list before 'DECLARE_DMA_U
NMAP_ADDR'

drivers/net/cxgb3/sge.c:120: error: expected specifier-qualifier-list before 'DECLARE_DMA_UNMAP_ADDR'
drivers/net/cxgb3/sge.c:210: error: expected specifier-qualifier-list before 'DECLARE_DMA_UNMAP_ADDR'

-- 
~Randy
