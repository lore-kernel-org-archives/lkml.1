Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbZCHWSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbZCHWSd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 18:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbZCHWSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 18:18:24 -0400
Received: from h155.mvista.com ([63.81.120.155]:6013 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753521AbZCHWSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 18:18:23 -0400
Message-ID: <49B44428.7070605@ru.mvista.com>
Date: Mon, 09 Mar 2009 01:18:16 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] ide: inline ide_dma_timeout() into ide_dma_timeout_retry()
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain> <20090220171154.25429.24988.sendpatchset@localhost.localdomain>
In-Reply-To: <20090220171154.25429.24988.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Since ide_dma_timeout() is only used by ide_dma_timeout_retry()
> inline it there.
>
> There should be no functional changes caused by this patch.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


