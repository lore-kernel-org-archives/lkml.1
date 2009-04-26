Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbZDZEF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbZDZEF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 00:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZDZEFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 00:05:13 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50382 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbZDZEFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 00:05:12 -0400
Message-ID: <49F3DD74.9030609@garzik.org>
Date: Sun, 26 Apr 2009 00:05:08 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: unsik Kim <donari75@gmail.com>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 3/3] mg_disk: use defines from <linux/ata.h>
References: <200904251510.03924.bzolnier@gmail.com>
In-Reply-To: <200904251510.03924.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> While at it:
> - remove MG_REG_HEAD_MUST_BE_ON define
> - remove MG_REG_CTRL_INTR_ENABLE define
> - remove MG_REG_HEAD_LBA_MODE define
> - remove unused defines
> 
> Cc: unsik Kim <donari75@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/block/mg_disk.c |  143 ++++++++++++++----------------------------------
>  1 file changed, 43 insertions(+), 100 deletions(-)

ACK

