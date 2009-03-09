Return-Path: <linux-kernel-owner+w=401wt.eu-S1751814AbZCIOgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbZCIOgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 10:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbZCIOgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 10:36:23 -0400
Received: from h155.mvista.com ([63.81.120.155]:23431 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750853AbZCIOgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 10:36:23 -0400
Message-ID: <49B52960.4000305@ru.mvista.com>
Date: Mon, 09 Mar 2009 17:36:16 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] ide: add ide_dma_prepare() helper
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain> <20090220171209.25429.87753.sendpatchset@localhost.localdomain>
In-Reply-To: <20090220171209.25429.87753.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Add ide_dma_prepare() helper.
>
> * Convert ide_issue_pc() and do_rw_taskfile() to use it.
>
> * Make ide_build_sglist() static.
>
> There should be no functional changes caused by this patch.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


