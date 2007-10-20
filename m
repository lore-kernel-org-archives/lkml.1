Return-Path: <linux-kernel-owner+w=401wt.eu-S966862AbXJTC5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966862AbXJTC5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 22:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067AbXJTC5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 22:57:23 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58414 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbXJTC5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 22:57:22 -0400
Message-ID: <47196E8C.5040003@garzik.org>
Date: Fri, 19 Oct 2007 22:57:16 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [git patch] libata build fix
References: <20071015221329.GA8778@havoc.gtf.org> <200710170123.43244.bzolnier@gmail.com>
In-Reply-To: <200710170123.43244.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Tuesday 16 October 2007, Jeff Garzik wrote:
> 
>> Jeff Garzik (1):
>>       [libata] pata_cs5536: new API build fix
> 
> We probably need also this one for pata_cs5536:
> 
> [PATCH] pata_cs5536: MWDMA fix
> 
> * Fix out-of-bound array access for MWDMA modes.
> 
> * Bump driver version.
> 
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Jeff Garzik <jeff@garzik.org>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ata/pata_cs5536.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

applied


