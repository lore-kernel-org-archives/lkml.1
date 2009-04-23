Return-Path: <linux-kernel-owner+w=401wt.eu-S1757115AbZDWLjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115AbZDWLjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 07:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbZDWLjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 07:39:11 -0400
Received: from brick.kernel.dk ([93.163.65.50]:43805 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbZDWLjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 07:39:10 -0400
Date: Thu, 23 Apr 2009 13:39:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block bits for 2.6.30-rc3
Message-ID: <20090423113909.GC4593@kernel.dk>
References: <20090423103523.GT4593@kernel.dk> <49F04D7C.2040807@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F04D7C.2040807@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23 2009, Jeff Garzik wrote:
> Jens Axboe wrote:
>> Bartlomiej Zolnierkiewicz (1):
>>       block: enable by default support for large devices and files on 32-bit archs
>
> Although I strongly support this change -- is this really appropriate  
> for -rc3?
>
> I know it's only a one-line Kconfig change, but still...  this does not  
> seem to fall into the category of "regression fix."

It was sitting for about a month before being included, but yes it is
probably something that should have gone in before -rc1. I'll defer to
Linus, I can easily postpone it to 2.6.31-rc1 it need be.

-- 
Jens Axboe

