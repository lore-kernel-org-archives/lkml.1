Return-Path: <linux-kernel-owner+w=401wt.eu-S932311AbZAQUVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbZAQUVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 15:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755988AbZAQUU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 15:20:59 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:10873 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755144AbZAQUU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 15:20:58 -0500
Message-ID: <49723DA4.4@ru.mvista.com>
Date: Sat, 17 Jan 2009 23:20:52 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] ide: move ide_dma_timeout_retry() to ide-dma.c
References: <20090115200032.17294.84745.sendpatchset@localhost.localdomain> <20090115200101.17294.76431.sendpatchset@localhost.localdomain>
In-Reply-To: <20090115200101.17294.76431.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Move ide_dma_timeout_retry() to ide-dma.c and add static inline
> version for CONFIG_BLK_DEV_IDEDMA=n.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>   

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


