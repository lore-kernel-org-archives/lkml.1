Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbXJXLfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbXJXLfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbXJXLfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:35:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60522 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119AbXJXLfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:35:05 -0400
Message-ID: <471F2DE5.3060708@garzik.org>
Date: Wed, 24 Oct 2007 07:35:01 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: FUJITA Tomonori <tomof@acm.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, kyle@parisc-linux.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH -mm 08/11] parisc: make iommu respect the segment size
 limits
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org> <20071024172113Y.tomof@acm.org>
In-Reply-To: <20071024172113Y.tomof@acm.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> This patch makes iommu respect segment size limits when merging sg
> lists.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/parisc/ccio-dma.c      |    2 +-
>  drivers/parisc/iommu-helpers.h |    7 ++++++-
>  drivers/parisc/sba_iommu.c     |    2 +-
>  3 files changed, 8 insertions(+), 3 deletions(-)

patches 3-8 look OK

