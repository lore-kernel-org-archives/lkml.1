Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbZCHW0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbZCHW0w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 18:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbZCHW0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 18:26:43 -0400
Received: from h155.mvista.com ([63.81.120.155]:6058 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754224AbZCHW0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 18:26:42 -0400
Message-ID: <49B4461B.1030308@ru.mvista.com>
Date: Mon, 09 Mar 2009 01:26:35 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/10] trm290: use custom ->dma_{start,end} to handle
 trm290_prepare_drive()
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain> <20090220171222.25429.23636.sendpatchset@localhost.localdomain>
In-Reply-To: <20090220171222.25429.23636.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> Use custom ->dma_{start,end} methods to handle trm290_prepare_drive()
> there instead of in ->dma_setup method.
>
> There should be no functional changes caused by this patch
> (DMA support is disabled currently in trm290.c).
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>   

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


