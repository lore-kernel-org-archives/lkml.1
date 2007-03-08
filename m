Return-Path: <linux-kernel-owner+w=401wt.eu-S1751911AbXCHOYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbXCHOYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 09:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbXCHOYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 09:24:52 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:46431 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbXCHOYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 09:24:50 -0500
Message-ID: <45F01CAB.7090405@garzik.org>
Date: Thu, 08 Mar 2007 09:24:43 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: libata: Fix host->simplex_claimed != ap typo
References: <87lki7zuoz.fsf@duaron.myhome.or.jp>
In-Reply-To: <87lki7zuoz.fsf@duaron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
> Hi,
> 
> the following patch is needed to boot my laptop using pata_ali.ko, at least.
> Please apply.

Someone else caught this as well.  This will go upstream today.

	Jeff


