Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbZE2DvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbZE2DvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 23:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbZE2DvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 23:51:09 -0400
Received: from fall-curlleaf.atl.sa.earthlink.net ([207.69.195.105]:49657 "EHLO
	fall-curlleaf.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306AbZE2DvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 23:51:08 -0400
X-Greylist: delayed 675 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 May 2009 23:51:08 EDT
Message-ID: <4A1F58E8.3090307@earthlink.net>
Date: Thu, 28 May 2009 23:39:20 -0400
From: Robert Reif <reif@earthlink.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090303 SeaMonkey/1.1.15 (Ubuntu-1.1.15+nobinonly-0ubuntu2)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: davem@davemloft.net, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] sparc: unify dma-mapping_32.h and dma-mapping_64.h
References: <1242354191-6232-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1242354191-6232-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> This patchset unifies dma-mapping_32.h and dma-mapping_64.h, that is,
> it uses dma-mapping.h instead and removes dma-mapping_32.h and
> dma-mapping_64.h.
>   
I just boot tested this patch set on sparc32 and it works fine.
