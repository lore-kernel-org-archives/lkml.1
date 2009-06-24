Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbZFXMXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbZFXMXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 08:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbZFXMXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 08:23:04 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:1271
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750957AbZFXMXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 08:23:04 -0400
Message-ID: <4A421AA6.5060908@panasas.com>
Date: Wed, 24 Jun 2009 15:23:02 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Amerigo Wang <xiyou.wangcong@gmail.com>
CC: Paul Menage <menage@google.com>, akpm@linux-foundation.org,
       jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [uml-devel] [PATCH] UML: Fix some apparent bitrot
References: <20090620005524.25582.69677.stgit@menage.mtv.corp.google.com> <20090622024610.GC5893@cr0.nay.redhat.com>
In-Reply-To: <20090622024610.GC5893@cr0.nay.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2009 12:23:06.0103 (UTC) FILETIME=[86EB2870:01C9F4C6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2009 05:46 AM, Amerigo Wang wrote:
> On Fri, Jun 19, 2009 at 05:55:24PM -0700, Paul Menage wrote:
>> UML: Fix some apparent bitrot
>>
>> - migration of net_device methods into net_device_ops
>> - dma_sync_single() changes
>> - cpumask_clear() -> cpumask_clear_cpu()
>>
>> Signed-off-by: Paul Menage <menage@google.com>
> 
> 
> Looks good.
> 
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> 

Dear Jeff, Amerigo

who is pushing this patch to Linus for 2.6.31. (ASAP)
Linus has threatened to cut -rc1 soon, and it is
unbuildable for UML currently.

Thanks in advance
Boaz
