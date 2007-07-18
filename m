Return-Path: <linux-kernel-owner+w=401wt.eu-S1760153AbXGRVIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153AbXGRVIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 17:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbXGRVHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 17:07:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:49159 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbXGRVHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 17:07:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=q4BVx6WfDk+pWY8NqDzvHfcu+nmqCsInjfUSBKECKy+et3DTNfQ9GXnHPGkv7fSERmCgOpLmHfTMf1tWnu7fDfF4P8RuhTK+iHNR9RTyyPlUEJu0ZUaz5KuQ5MOOClShy4PO8fUlwHs6//TaGIahCpQpWbCEpMuZlJnY2k5JgFM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: FUJITA Tomonori <tomof@acm.org>
Subject: Re: block/bsg.c
Date: Wed, 18 Jul 2007 22:39:38 +0200
User-Agent: KMail/1.9.6
Cc: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20070717190705T.fujita.tomonori@lab.ntt.co.jp> <200707172252.25729.bzolnier@gmail.com> <20070718072644F.tomof@acm.org>
In-Reply-To: <20070718072644F.tomof@acm.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707182239.38293.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 18 July 2007, FUJITA Tomonori wrote:

> They were fixed. Please check the latest code:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git bsg
> 
> We wait for Linus to pull from it.

It has been merged.  Thanks for fixing the mentioned issues.

Thanks,
Bart
