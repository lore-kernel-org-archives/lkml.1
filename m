Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbZFDIpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbZFDIpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbZFDIpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:45:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39416
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091AbZFDIpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:45:30 -0400
Date: Thu, 04 Jun 2009 01:45:31 -0700 (PDT)
Message-Id: <20090604.014531.34506854.davem@davemloft.net>
To: reif@earthlink.net
Cc: fujita.tomonori@lab.ntt.co.jp, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] sparc: unify dma-mapping_32.h and dma-mapping_64.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A1F58E8.3090307@earthlink.net>
References: <1242354191-6232-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<4A1F58E8.3090307@earthlink.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Reif <reif@earthlink.net>
Date: Thu, 28 May 2009 23:39:20 -0400

> FUJITA Tomonori wrote:
>> This patchset unifies dma-mapping_32.h and dma-mapping_64.h, that is,
>> it uses dma-mapping.h instead and removes dma-mapping_32.h and
>> dma-mapping_64.h.
>>   
> I just boot tested this patch set on sparc32 and it works fine.

All applied and I added a tested-by: for Robert to the commits.

Thanks!
